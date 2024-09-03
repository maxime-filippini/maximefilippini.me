import blog/components.{Logo, NavItem, Separator}
import blog/dates
import blog/page
import blog/post.{type Post}
import envoy
import gleam/dict
import gleam/list
import gleam/order
import lustre/ssg
import simplifile

const out_dir = "dist"

const assets_dir = "priv/assets"

pub type Error {
  ParsingError
}

type Environment {
  Environment(local: Bool)
}

fn make_env() -> Environment {
  let local = case envoy.get("GLEAM_LOCAL") {
    Ok(v) ->
      case v {
        "0" | "F" | "false" -> False
        _ -> True
      }
    Error(_) -> True
  }

  Environment(local:)
}

pub fn main() {
  let env = make_env()

  let all_posts =
    parse_posts("posts")
    |> list.filter(fn(post) {
      case env.local {
        True -> True
        False -> !post.meta.draft
      }
    })
    |> list.sort(by: fn(first, second) {
      order.negate(dates.compare(
        first.meta.publication_date,
        second.meta.publication_date,
      ))
    })

  let posts_with_slugs =
    all_posts
    |> list.map(fn(post) { #(post.meta.slug, post) })
    |> dict.from_list

  let nav_items = [
    Logo(
      url: "/",
      title: "Maxime Filippini",
      short_title: "M.F.",
      color: "#a6d189",
    ),
    Separator,
    NavItem(url: "/blog/index.html", title: "Blog"),
    NavItem(url: "/apps.html", title: "Apps"),
    NavItem(url: "/about.html", title: "About"),
  ]
  ssg.new(out_dir)
  |> ssg.add_static_route("/", page.index(nav_items))
  |> ssg.add_static_route("/about", page.about(nav_items))
  |> ssg.add_static_route("/apps", page.apps(nav_items))
  |> ssg.add_static_route("/404", page.not_found())
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
