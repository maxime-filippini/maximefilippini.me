// The functions that return the pages of the blog

import blog/components.{type NavItem, nav_bar, page_head}
import blog/post.{type Post}
import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{body, html}

pub type Page {
  Page
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

// A blog post
pub fn post(nav_items: List(NavItem)) -> fn(Post) -> Element(Nil) {
  fn(post: Post) -> Element(Nil) {
    let title = post.meta.title
    let contents = [
      components.page_title(title),
      html.div([class("text-lg")], post.body),
    ]
    make_page(nav_items:, title:, contents:)
  }
}

// The blog index
pub fn blog(nav_items: List(NavItem), posts: List(Post)) -> Element(Nil) {
  let title = "My blog"
  let post_cards = posts |> list.map(post.to_abstract_card)
  let contents = [
    components.page_title(title),
    components.under_construction_banner(),
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
