/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx,gleam}",
  ],
  theme: {
    extend: {
      fontFamily: {
        display: ["Special Elite", "sans-serif"],
      },
    },
  },
  plugins: [],
}

