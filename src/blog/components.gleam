import gleam/io
import gleam/list
import lustre/attribute.{type Attribute, attribute, class, href, name, rel, src}
import lustre/element.{type Element, element, text}
import lustre/element/html.{a, head, li, link, meta, nav, script, ul}

pub type NavItem {
  Logo(url: String, title: String, color: String)
  NavItem(url: String, title: String)
  Separator
}

pub type NavBar {
  NavBar(items: List(NavItem))
}

const stylesheet_path = "/stylesheets/styles.css"

const hljs_script_url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"

const hljs_python_script_url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/languages/python.min.js"

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
        Logo(url:, title:, color:) ->
          li([class("text-2xl text-[" <> color <> "]")], [
            a([href(url)], [text(title)]),
          ])
        NavItem(url:, title:) ->
          li([class("text-lg")], [a([href(url)], [text(title)])])
      }
    })

  nav([class("w-full py-4 sticky top-0 bg-bg border-b-2 border-surface-0")], [
    ul([class("flex gap-8 justify-center")], list_items),
  ])
}

pub fn h1(text t: String, class c: String) -> Element(Nil) {
  html.h1([class(c)], [text(t)])
}

pub fn h2(text t: String, class c: String) -> Element(Nil) {
  html.h2([class(c)], [text(t)])
}

pub fn article_card(
  id id: String,
  title title: String,
  abstract abstract: String,
  tags tags: List(String),
) -> Element(Nil) {
  let tag_pills = html.div([class("flex gap-2")], tags |> list.map(tag_pill))
  let tag_div = case tags {
    [] -> html.div([], [])
    _ ->
      html.div([class("flex h-8 align-center")], [
        html.p([class("w-16")], [text("Tags")]),
        tag_pills,
      ])
  }

  html.a([attribute.href("/blog/" <> id <> ".html")], [
    html.div(
      [
        attribute.id(id),
        class(
          "border border-width-1 rounded-md flex flex-col gap-2 p-4 bg-surface-0",
        ),
      ],
      [
        h2(title, class: "text-2xl text-bold"),
        tag_div,
        html.p([], [text(abstract)]),
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
  html.p([class("mb-3")], elements)
}

pub fn page_title(title: String) -> Element(Nil) {
  h1(text: title, class: "text-5xl mb-6 mt-6 font-bold")
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
  html.div([class("h-64 bg-surface-0 flex rounded-xl p-8 m-8")], [
    warning_svg(),
    html.div([class("flex flex-col justify-center w-full gap-4")], [
      h2(class: "text-3xl text-center w-full", text: "Under construction"),
      html.p([class("text-xl italic text-center w-full")], [
        text("Please be patient."),
      ]),
    ]),
  ])
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
  html.div([class("bg-catp-green text-bg rounded-full px-4 py-1")], [text(tag)])
}
