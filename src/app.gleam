import gleam/int
import gleam/list
import lustre
import lustre/element/html.{button, div, h1, hr, img, p}
import lustre/element.{text}
import lustre/event.{on_click}
import lustre/attribute.{alt, class, src}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, render)
  let assert Ok(_) = lustre.start(app, "#app")

  Nil
}

type Element =
  element.Element(Msg)

// MODEL -----------------------------------------------------------------------

type Model {
  Model(log: List(Element), show_header: Bool)
}

fn init() -> Model {
  Model(log: [], show_header: True)
}

// UPDATE ----------------------------------------------------------------------

type Msg {
  Pressed(Int)
  Reset
  Undo
}

fn update(state: Model, msg: Msg) -> Model {
  let Model(log, show_header) = state

  case msg {
    Pressed(light) ->
      Model([light_row(light, list.length(log) + 1), ..log], False)
    Reset -> Model([], show_header)
    Undo ->
      case log {
        [_, ..rest] -> Model(rest, show_header)
        _ -> state
      }
  }
}

// VIEW ------------------------------------------------------------------------

fn render(state: Model) -> Element {
  let Model(log, show_header) = state

  let button_style = "bg-stone-700 px-4 py-1 rounded text-white"

  let divider = hr([class("border-stone-800")])

  let scroll_indicator = [
    div(
      [
        class(
          "h-8 fixed bottom-0 left-0 right-0 bg-gradient-to-t from-stone-950 z-10",
        ),
      ],
      [],
    ),
  ]

  let header = case show_header {
    True -> [
      div(
        [
          class(
            "bg-gradient-to-b from-stone-900 to-stone-950 rounded font-display text-stone-500 border border-stone-800 p-4 flex items-center gap-3 mb-3",
          ),
        ],
        [
          div(
            [
              class(
                "w-10 h-10 rounded-full bg-stone-800 text-stone-500 font-mono flex items-center justify-center flex-shrink-0 font-bold",
              ),
            ],
            [text("!")],
          ),
          p(
            [],
            [
              text(
                "'Spooktober' 2023 has come to a close, and the Light Squencer is no longer available in game.",
              ),
            ],
          ),
        ],
      ),
      p([class("font-display text-sm italic")], [text("It's the...")]),
      div(
        [class("flex justify-between")],
        [
          h1(
            [
              class(
                "text-4xl font-display text-transparent bg-clip-text bg-gradient-to-tr from-amber-700 to-amber-400",
              ),
            ],
            [text("Memory O' Matic!")],
          ),
          img([
            class("h-10 hidden sm:block"),
            src("./aj.png"),
            alt("Animal Jam Logo"),
          ]),
        ],
      ),
      p(
        [class("font-display text-justify")],
        [
          text(
            "Having trouble remembering light sequences? You have come to the right place! Enter the squence into the Memory O' Matic as it appears in-game, then use the log to recall it!",
          ),
        ],
      ),
      divider,
    ]
    False -> []
  }

  let light_buttons = [
    div(
      [class("flex gap-3")],
      [light_button(1), light_button(2), light_button(3), light_button(4)],
    ),
    divider,
  ]

  let log = case log {
    [] -> [
      p([class("italic text-center")], [text("Start loggin' those sequences!")]),
    ]
    _ -> [
      div(
        [class("flex gap-3")],
        [
          button([class(button_style), on_click(Reset)], [text("Reset")]),
          button([class(button_style), on_click(Undo)], [text("Undo")]),
        ],
      ),
      divider,
      div([class("space-y-3")], list.reverse(log)),
    ]
  }

  div(
    [
      class(
        "mx-auto max-w-xl px-4 py-8 sm:pt-16 text-stone-400 flex flex-col gap-3 relative",
      ),
    ],
    scroll_indicator
    |> list.append(header)
    |> list.append(light_buttons)
    |> list.append(log),
  )
}

fn light_button(which: Int) -> Element {
  let style =
    "flex-1 aspect-square rounded-full text-2xl flex items-center justify-center font-bold text-white touch-manipulation transition hover:scale-105 active:scale-95"

  button(
    [class(style <> light_bg(which)), on_click(Pressed(which))],
    [text(int.to_string(which))],
  )
}

fn light_row(which: Int, number: Int) -> Element {
  let base_style =
    "w-10 h-10 rounded-full flex items-center justify-center text-white font-bold"

  let blank = div([class(base_style <> " bg-stone-800")], [])

  let color = div([class(base_style <> light_bg(which))], [])

  let row = case which {
    1 -> [color, blank, blank, blank]
    2 -> [blank, color, blank, blank]
    3 -> [blank, blank, color, blank]
    4 -> [blank, blank, blank, color]
  }

  div([class("flex gap-3 items-center")], [text(int.to_string(number)), ..row])
}

fn light_bg(which: Int) -> String {
  case which {
    1 -> " bg-green-700 hover:bg-green-600"
    2 -> " bg-red-700 hover:bg-red-600"
    3 -> " bg-yellow-700 hover:bg-yellow-600"
    4 -> " bg-fuchsia-700 hover:bg-fuchsia-600"
  }
}
