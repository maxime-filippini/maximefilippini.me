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
        "catp-green": "#a6e3a1",
      },
      fontFamily: {
        roboto: ["Roboto", "sans-serif"],
      },
    },
  },
  plugins: [],
};
