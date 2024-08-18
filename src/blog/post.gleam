// Functions dealing with blog posts

import blog/components
import gleam/dynamic
import gloml
import lustre/element.{type Element}
import markdown
import simplifile

pub type Post {
  Post(meta: Metadata, body: List(Element(Nil)))
}

pub type Error {
  ParsingError
}

pub type Metadata {
  Metadata(id: String, title: String, slug: String, abstract: String)
}

// Parse the metadata of a post
pub fn parse_metadata(
  meta_string: String,
) -> Result(Metadata, gloml.DecodeError) {
  let decoder =
    dynamic.decode4(
      Metadata,
      dynamic.field("id", dynamic.string),
      dynamic.field("title", dynamic.string),
      dynamic.field("slug", dynamic.string),
      dynamic.field("abstract", dynamic.string),
    )

  gloml.decode(meta_string, decoder)
}

// Convert posts to headers, cards, etc. 
pub fn to_abstract_card(post: Post) -> Element(Nil) {
  components.article_card(
    abstract: post.meta.abstract,
    id: post.meta.slug,
    title: post.meta.title,
  )
}

// Parse a markdown file as a post
// Raises an error if there was an issue in parsing the body or the metadata
pub fn read(path: String) -> Result(Post, Error) {
  let assert Ok(contents) = simplifile.read(path)

  case markdown.parse(contents) {
    Ok(#(meta_string, parsed_body)) -> {
      let parsed_meta = parse_metadata(meta_string)

      case parsed_meta {
        Ok(meta) -> Ok(Post(meta: meta, body: parsed_body))
        _ -> Error(ParsingError)
      }
    }
    _ -> Error(ParsingError)
  }
}
