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
  let assert Ok(_) = lustre.start(app, "div")

  Nil
}

type Element =
  element.Element(Msg)

// MODEL -----------------------------------------------------------------------

type Model =
  List(Element)

fn init() -> Model {
  []
}

// UPDATE ----------------------------------------------------------------------

type Msg {
  Pressed(Int)
  Reset
  Undo
}

fn update(state: Model, msg: Msg) -> Model {
  case msg {
    Pressed(light) -> [light_row(light, list.length(state) + 1), ..state]
    Reset -> []
    Undo ->
      case state {
        [_, ..rest] -> rest
        _ -> []
      }
  }
}

// VIEW ------------------------------------------------------------------------

fn render(state: Model) -> Element {
  let light_style =
    "flex-1 aspect-square rounded-full bg-stone-500 text-2xl flex items-center justify-center font-bold text-white transition hover:bg-stone-400 hover:scale-105 active:scale-95"

  let button_style = "bg-stone-700 px-4 py-1 rounded text-white"

  let divider = hr([class("border-stone-800")])

  let log = case state {
    [] -> [
      p([class("text-center italic")], [text("Start loggin' those sequences!")]),
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
      div([class("space-y-3")], list.reverse(state)),
    ]
  }

  div(
    [
      class(
        "mx-auto max-w-xl px-4 pt-16 pb-4 text-stone-400 space-y-3 relative",
      ),
    ],
    [
      p([class("font-display text-sm italic")], [text("It's the...")]),
      div(
        [class("flex justify-between")],
        [
          h1(
            [class("text-4xl font-display text-amber-500")],
            [text("Memory O' Matic!")],
          ),
          img([class("h-10"), src("/aj.png"), alt("Animal Jam Logo")]),
        ],
      ),
      p(
        [class("font-display text-justify")],
        [
          text(
            "Having trouble remebering light sequences? You have come to the right place! Enter the squence into the Memory O' Matic as it appears in-game, then use the log to recall it!",
          ),
        ],
      ),
      divider,
      div(
        [class("flex gap-3")],
        [
          button([class(light_style), on_click(Pressed(1))], [text("1")]),
          button([class(light_style), on_click(Pressed(2))], [text("2")]),
          button([class(light_style), on_click(Pressed(3))], [text("3")]),
          button([class(light_style), on_click(Pressed(4))], [text("4")]),
        ],
      ),
      divider,
      ..log
    ],
  )
}

fn light_row(which: Int, number: Int) -> Element {
  let base_style =
    "w-10 h-10 rounded-full flex items-center justify-center text-stone-900 font-bold"

  let empty = div([class(base_style <> " bg-stone-700 animate-pulse")], [])

  let full =
    div([class(base_style <> " bg-amber-500")], [text(int.to_string(which))])

  let row = case which {
    1 -> [full, empty, empty, empty]
    2 -> [empty, full, empty, empty]
    3 -> [empty, empty, full, empty]
    4 -> [empty, empty, empty, full]
  }

  div([class("flex gap-3 items-center")], [text(int.to_string(number)), ..row])
}
