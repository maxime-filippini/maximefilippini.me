import blog/components
import gleam/io
import gleam/list
import gleam/string
import lustre/attribute.{attribute, class}
import lustre/element.{type Element}
import lustre/element/html

fn word_count(value: String) -> Int {
  let out = string.split(value, on: " ")
  list.length(out)
}

// Create an HTML element from AST components
pub fn code(src: String, lang: String) -> #(Element(msg), Int) {
  let attributes = [
    attribute("data-lang", lang),
    attribute.class("not-prose language-" <> lang),
  ]

  let elts =
    html.pre(
      [
        attribute.class(
          "my-6 bg-surface-0 p-4 rounded-md overflow-x-scroll text-sm sm:text-lg",
        ),
      ],
      [html.code(attributes, [html.text(src)])],
    )

  #(elts, 0)
}

pub fn h2(value: String, margin margin: Bool) -> Element(a) {
  let base = "sm:text-3xl text-xl font-bold"
  let cls = case margin {
    True -> base <> " my-6"
    False -> base
  }
  let elts = html.h2([class(cls)], [html.text(value)])
  elts
}

pub fn heading(depth: Int, content: String) -> #(Element(Nil), Int) {
  let elt = case depth {
    1 ->
      components.h1(content, class: "sm:text-5xl text-3xl mb-6 mt-6 font-bold")
    2 -> h2(content, margin: True)
    3 -> html.h3([], [html.text(content)])
    4 -> html.h4([], [html.text(content)])
    5 -> html.h5([], [html.text(content)])
    _ -> html.h6([], [html.text(content)])
  }
  #(elt, word_count(content))
}

pub fn error() -> #(Element(msg), Int) {
  let elt =
    html.blockquote([], [html.text("There was an unhandled md element!")])
  #(elt, 0)
}

pub fn empty() -> #(Element(msg), Int) {
  let elt = html.div([], [])
  #(elt, 0)
}

pub fn inline_code(src: String) -> #(Element(msg), Int) {
  let elt = html.code([], [element.text(src)])
  #(elt, 0)
}

pub fn link(
  url: String,
  content: #(List(Element(msg)), Int),
) -> #(Element(msg), Int) {
  let elt = html.a([attribute.href(url)], content.0)
  #(elt, content.1)
}

pub fn list(
  ordered: Bool,
  items: #(List(Element(msg)), Int),
) -> #(Element(msg), Int) {
  let elt = case ordered {
    True ->
      html.ol([attribute.class("list-decimal list-outside ml-4")], items.0)
    False -> html.ul([attribute.class("list-disc list-outside ml-4")], items.0)
  }
  #(elt, items.1)
}

pub fn list_item(content: #(List(Element(msg)), Int)) -> #(Element(msg), Int) {
  let elt = html.li([], content.0)
  #(elt, content.1)
}

pub fn paragraph(content: #(List(Element(msg)), Int)) -> #(Element(msg), Int) {
  let elt = components.paragraph(content.0)
  #(elt, content.1)
}

pub fn strong(content: #(List(Element(msg)), Int)) -> #(Element(msg), Int) {
  let elt = html.strong([], content.0)
  #(elt, content.1)
}

pub fn text(content: String) -> #(Element(msg), Int) {
  let elt = html.text(content)
  #(elt, word_count(content))
}

pub fn blockquote(content: #(List(Element(msg)), Int)) -> #(Element(msg), Int) {
  let elt = html.blockquote([], content.0)
  #(elt, content.1)
}

pub fn thematic_break() -> #(Element(msg), Int) {
  let elt = html.hr([])
  #(elt, 0)
}

pub fn emphasis(content: #(List(Element(msg)), Int)) -> #(Element(msg), Int) {
  let elt = html.em([], content.0)
  #(elt, content.1)
}
