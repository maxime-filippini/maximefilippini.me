import gleam/list
import gleam/string
import lustre/attribute.{
  type Attribute, attribute, class, href, name, rel, src, type_,
}
import lustre/element.{type Element, element, text}
import lustre/element/html.{a, head, li, link, meta, nav, script, ul}

pub type NavItem {
  Logo(url: String, title: String, short_title: String, color: String)
  NavItem(url: String, title: String)
  Separator
}

pub type NavBar {
  NavBar(items: List(NavItem))
}

const stylesheet_path = "/stylesheets/styles.css"

const hljs_script_url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"

const hljs_python_script_url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/languages/python.min.js"

const hljs_gleam_path = "/js/highlightjs.gleam.js"

pub fn page_head(title t: String) {
  head([], [
    charset("utf-8"),
    viewport([
      content("width=device-width, initial-scale=1.0, viewport-fit=cover"),
    ]),
    link([rel("stylesheet"), href("/stylesheets/hljs.css")]),
    link([rel("stylesheet"), href(stylesheet_path)]),
    title(t),
    favicon("🖥"),
    script([src(hljs_script_url)], ""),
    script([src(hljs_python_script_url)], ""),
    script([type_("text/javascript"), src(hljs_gleam_path)], ""),
    script([], "hljs.highlightAll();"),
    ..font()
  ])
}

pub fn title(title t: String) {
  html.title([], t)
}

fn content(value: String) -> Attribute(a) {
  attribute("content", value)
}

fn charset(value: String) -> Element(a) {
  meta([attribute("charset", value)])
}

fn meta_named(meta_name: String, attributes: List(Attribute(a))) -> Element(a) {
  meta([name(meta_name), ..attributes])
}

fn viewport(attributes: List(Attribute(a))) -> Element(a) {
  meta_named("viewport", attributes)
}

pub fn container(elements: List(Element(Nil))) -> Element(Nil) {
  html.div([class("container max-w-3xl mx-auto flex flex-col")], elements)
}

pub fn nav_bar(nav_items: List(NavItem)) -> Element(Nil) {
  let list_items =
    nav_items
    |> list.map(fn(item) {
      case item {
        Separator -> html.div([class("w-4 border-r-2 mr-4")], [])
        Logo(url:, title:, short_title:, color:) ->
          html.div([], [
            li([class("text-2xl text-[" <> color <> "] sm:block hidden")], [
              a([href(url)], [text(title)]),
            ]),
            li([class("text-2xl text-[" <> color <> "] block sm:hidden")], [
              a([href(url)], [text(short_title)]),
            ]),
          ])
        NavItem(url:, title:) ->
          li([class("text-lg")], [a([href(url)], [text(title)])])
      }
    })

  nav(
    [
      class(
        "w-full py-4 sticky top-0 bg-bg border-b-2 border-surface-0 sm:px-0 px-8",
      ),
    ],
    [ul([class("flex gap-8 justify-center")], list_items)],
  )
}

pub fn h1(text t: String, class c: String) -> Element(Nil) {
  html.h1([class(c)], [text(t)])
}

pub fn h2(text t: String, class c: String) -> Element(Nil) {
  html.h2([class(c)], [text(t)])
}

pub fn tag_menu(tags: List(String)) -> Element(Nil) {
  let tag_pills = html.div([class("flex gap-2")], tags |> list.map(tag_pill))
  case tags {
    [] -> html.div([], [])
    _ ->
      html.div([class("flex h-8 align-center")], [
        html.p([class("w-16 flex items-center")], [text("Tags")]),
        tag_pills,
      ])
  }
}

pub fn article_card(
  id id: String,
  title title: String,
  abstract abstract: String,
  tags tags: List(String),
) -> Element(Nil) {
  html.a([attribute.href("/blog/" <> id <> ".html")], [
    html.div(
      [
        attribute.id(id),
        class(
          "shadow-md rounded-lg flex flex-col gap-2 p-4 bg-surface-1 hover:bg-surface-0 hover:shadow-xl duration-200",
        ),
      ],
      [
        h2(title, class: "text-2xl text-bold"),
        tag_menu(tags),
        html.p([class("italic")], [text(abstract)]),
      ],
    ),
  ])
}

fn font() -> List(Element(Nil)) {
  [
    link([rel("preconnect"), href("https://fonts.googleapis.com")]),
    link([rel("preconnect"), href("https://fonts.gstatic.com")]),
    link([
      rel("stylesheet"),
      href(
        "https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap",
      ),
    ]),
  ]
}

pub fn paragraph(elements: List(Element(a))) -> Element(a) {
  html.p([class("my-3 align-middle")], elements)
}

pub fn page_title(title: String) -> Element(Nil) {
  h1(text: title, class: "sm:text-5xl text-3xl mb-6 mt-6 font-bold")
}

pub fn favicon(emoji: String) -> Element(Nil) {
  link([
    rel("icon"),
    href(
      "data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>"
      <> emoji
      <> "</text></svg>",
    ),
  ])
}

pub fn img(filename: String) -> Element(Nil) {
  html.img([attribute.src(filename)])
}

pub fn post_cover_img(filename: String) -> Element(Nil) {
  html.img([
    attribute.src(filename),
    class("h-[300px] w-full object-cover my-4 rounded-lg"),
  ])
}

pub fn under_construction_banner() -> Element(Nil) {
  html.div(
    [class("h-64 bg-surface-0 flex sm:flex-row flex-col rounded-xl p-8 m-8")],
    [
      warning_svg(),
      html.div([class("flex flex-col justify-center w-full gap-4")], [
        h2(class: "text-3xl text-center w-full", text: "Under construction"),
        html.p([class("text-xl italic text-center w-full")], [
          text("Please be patient."),
        ]),
      ]),
    ],
  )
}

pub fn warning_svg() -> Element(Nil) {
  html.svg(
    [
      attribute("fill", "none"),
      attribute("viewBox", "0 0 24 24"),
      attribute("stroke-width", "1.5"),
      attribute("stroke", "currentColor"),
      class("m-4"),
    ],
    [
      element(
        "path",
        [
          attribute("stroke-linecap", "round"),
          attribute("stroke-linejoin", "round"),
          attribute(
            "d",
            "M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 "
              <> "0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 "
              <> "0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z",
          ),
        ],
        [],
      ),
    ],
  )
}

pub fn tag_pill(tag: String) -> Element(Nil) {
  let color = case string.lowercase(tag) {
    "gleam" -> "bg-gleam-pink"
    _ -> "bg-catp-green"
  }
  html.div([class("text-bg rounded-full px-4 py-1 " <> color)], [text(tag)])
}
