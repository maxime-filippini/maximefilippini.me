// The functions that return the pages of the blog

import blog/components.{type NavItem, nav_bar, page_head}
import blog/post.{type Post}
import gleam/int
import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{body, html}

pub type Page {
  Page
}

fn minutes_to_read(word_count: Int) -> String {
  let min = word_count / 200

  case min {
    1 -> "1 minute"
    min -> int.to_string(min) <> " minutes"
  }
}

pub fn make_page(
  nav_items nav_items: List(NavItem),
  title title: String,
  contents contents: List(Element(Nil)),
) -> Element(Nil) {
  html([], [
    page_head(title),
    body([class("bg-bg text-white font-roboto")], [
      components.container([
        nav_bar(nav_items),
        html.div([class("p-4")], contents),
      ]),
    ]),
  ])
}

pub fn index(nav_items: List(NavItem)) -> Element(Nil) {
  let title = "Maxime Filippini"
  let contents = [
    components.page_title(title),
    components.under_construction_banner(),
  ]

  make_page(nav_items:, title:, contents:)
}

pub fn not_found() -> Element(Nil) {
  let contents = [html.text("Nothing to see here!")]

  html([], [
    body([class("bg-bg text-white font-roboto")], [
      components.container([html.div([class("p-4")], contents)]),
    ]),
  ])
}

// A blog post
pub fn post(nav_items: List(NavItem)) -> fn(Post) -> Element(Nil) {
  fn(post: Post) -> Element(Nil) {
    let title = post.meta.title
    let contents = [
      components.page_title(title),
      components.tag_menu(post.meta.tags),
      html.p([class("mt-4 italic")], [
        html.text("Estimated read time: " <> minutes_to_read(post.word_count)),
      ]),
      html.article([class("text-lg mt-8")], post.body),
    ]
    let page = make_page(nav_items:, title:, contents:)
    page
  }
}

// The blog index
pub fn blog(nav_items: List(NavItem), posts: List(Post)) -> Element(Nil) {
  let title = "Blog"
  let post_cards = posts |> list.map(post.to_abstract_card)
  let contents = [
    components.page_title(title),
    html.div([class("flex flex-col gap-4")], post_cards),
  ]
  make_page(nav_items:, title:, contents:)
}

// The about page
pub fn about(nav_items: List(NavItem)) -> Element(Nil) {
  let title = "About me"
  let contents = [
    components.page_title(title),
    components.under_construction_banner(),
  ]
  make_page(nav_items:, title:, contents:)
}

pub fn apps(nav_items: List(NavItem)) -> Element(Nil) {
  let title = "My apps"

  let app_card = fn(id: String, title: String, description: String, url: String) {
    html.a([attribute.href(url)], [
      html.div(
        [
          attribute.id(id),
          class(
            "shadow-md rounded-lg flex flex-col gap-2 p-4 bg-surface-1 hover:bg-surface-0 hover:shadow-xl duration-200",
          ),
        ],
        [
          components.h2(title, class: "text-2xl text-bold"),
          html.p([class("italic")], [element.text(description)]),
        ],
      ),
    ])
  }

  let contents = [
    components.page_title(title),
    app_card(
      "time-tracker",
      "Time tracker",
      "A small app for tracking the time spent on tasks. Work in progress.",
      "https://tracker.maximefilippini.me",
    ),
  ]

  make_page(nav_items:, title:, contents:)
}
