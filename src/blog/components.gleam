import gleam/list
import lustre/attribute.{type Attribute, attribute, class, href, name, rel}
import lustre/element.{type Element, text}
import lustre/element/html.{a, head, li, link, meta, nav, ul}

pub type NavItem {
  Logo(url: String, title: String, color: String)
  NavItem(url: String, title: String)
  Separator
}

pub type NavBar {
  NavBar(items: List(NavItem))
}

const stylesheet_path = "/stylesheets/styles.css"

pub fn page_head(title t: String) {
  head([], [
    charset("utf-8"),
    viewport([
      content("width=device-width, initial-scale=1.0, viewport-fit=cover"),
    ]),
    link([rel("stylesheet"), href(stylesheet_path)]),
    title(t),
    favicon("🖥"),
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
  html.div([class("container max-w-3xl mx-auto mt-8 flex flex-col")], elements)
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

  nav([class("w-full py-4 sticky top-0 bg-bg")], [
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
) -> Element(Nil) {
  html.a([attribute.href("/blog/" <> id <> ".html")], [
    html.div(
      [
        attribute.id(id),
        class(
          "border border-width-1 rounded-md flex flex-col gap-2 p-4 bg-surface-0",
        ),
      ],
      [h2(title, class: "text-2xl text-bold"), html.p([], [text(abstract)])],
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
