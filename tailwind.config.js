/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./dist/**/*.{html,js}"],
  theme: {
    extend: {
      colors: {
        primary: "#5c6ac4",
        secondary: "#ecc94b",
        bg: "#24273a",
        "overlay-1": "#8087a2",
        "surface-0": "#363a4f",
        "surface-1": "#313244",
        "catp-green": "#a6e3a1",
        "gleam-pink": "#ffaff3",
      },
      fontFamily: {
        roboto: ["Roboto", "sans-serif"],
      },
    },
  },
  plugins: [],
};
