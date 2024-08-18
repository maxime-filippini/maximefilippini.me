import blog/components.{Logo, NavItem, Separator}
import blog/page
import blog/post.{type Post}
import gleam/dict
import gleam/list
import lustre/ssg
import simplifile

const out_dir = "priv/site"

const assets_dir = "priv/assets"

pub type Error {
  ParsingError
}

pub fn main() {
  let all_posts = parse_posts("posts")

  let posts_with_slugs =
    all_posts
    |> list.map(fn(post) { #(post.meta.slug, post) })
    |> dict.from_list

  let nav_items = [
    Logo(url: "/", title: "Maxime Filippini", color: "#a6d189"),
    Separator,
    NavItem(url: "/blog/index.html", title: "Blog"),
    NavItem(url: "/about.html", title: "About"),
  ]

  ssg.new(out_dir)
  |> ssg.add_static_route("/", page.index(nav_items))
  |> ssg.add_static_route("/about", page.about(nav_items))
  |> ssg.add_static_route("/blog/index", page.blog(nav_items, all_posts))
  |> ssg.add_dynamic_route("/blog", posts_with_slugs, page.post(nav_items))
  |> ssg.add_static_dir(assets_dir)
  |> ssg.build
}

fn parse_posts(path: String) -> List(Post) {
  let assert Ok(paths) = simplifile.read_directory(path)
  use file_path <- list.map(paths)
  let assert Ok(post) = post.read(path <> "/" <> file_path)
  post
}
