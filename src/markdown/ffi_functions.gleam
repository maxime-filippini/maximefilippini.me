import blog/components
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html

// Create an HTML element from AST components
pub fn code(src: String, lang: String) -> Element(msg) {
  let attributes = [
    attribute("data-lang", lang),
    attribute.class("not-prose language-" <> lang),
  ]
  html.pre(
    [
      attribute.class(
        "my-6 bg-surface-0 p-4 rounded-md overflow-x-scroll text-sm sm:text-lg",
      ),
    ],
    [html.code(attributes, [html.text(src)])],
  )
}

pub fn h2(value: String, margin margin: Bool) -> Element(a) {
  let base = "sm:text-3xl text-xl font-bold"
  let cls = case margin {
    True -> base <> " my-6"
    False -> base
  }
  html.h2([class(cls)], [text(value)])
}

pub fn heading(depth: Int, content: String) -> Element(Nil) {
  case depth {
    1 ->
      components.h1(content, class: "sm:text-5xl text-3xl mb-6 mt-6 font-bold")
    2 -> h2(content, margin: True)
    3 -> html.h3([], [text(content)])
    4 -> html.h4([], [text(content)])
    5 -> html.h5([], [text(content)])
    _ -> html.h6([], [text(content)])
  }
}

pub fn error() -> Element(msg) {
  html.blockquote([], [element.text("There was an unhandled md element!")])
}

pub fn empty() -> Element(msg) {
  html.div([], [])
}

pub fn inline_code(src: String) -> Element(msg) {
  html.code([], [text(src)])
}

pub fn link(url: String, content: List(Element(msg))) -> Element(msg) {
  html.a([attribute.href(url)], content)
}

pub fn list(ordered: Bool, items: List(Element(msg))) -> Element(msg) {
  case ordered {
    True -> html.ol([attribute.class("list-decimal list-outside ml-4")], items)
    False -> html.ul([attribute.class("list-disc list-outside ml-4")], items)
  }
}

pub fn list_item(content: List(Element(msg))) -> Element(msg) {
  html.li([], content)
}

pub fn paragraph(content: List(Element(msg))) -> Element(msg) {
  components.paragraph(content)
}

pub fn strong(content: List(Element(msg))) -> Element(msg) {
  html.strong([], content)
}

pub fn text(content: String) -> Element(msg) {
  element.text(content)
}

pub fn blockquote(content: List(Element(msg))) -> Element(msg) {
  html.blockquote([], content)
}

pub fn thematic_break() -> Element(msg) {
  html.hr([])
}

pub fn emphasis(content: List(Element(msg))) {
  html.em([], content)
}
