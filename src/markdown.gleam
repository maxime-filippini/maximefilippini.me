import gleam/int
import gleam/io
import gleam/result
import gleam/string
import lustre/element.{type Element}

pub type MetadataError {
  MissingMetadata
  MalformedMetaData
}

pub fn extract_metadata(
  contents: String,
) -> Result(#(String, String), MetadataError) {
  let contents = string.trim(contents)

  case contents {
    "---\n" <> rest -> {
      case string.split_once(rest, on: "---\n") {
        Ok(res) -> Ok(res)
        _ -> Error(MalformedMetaData)
      }
    }
    _ -> Error(MissingMetadata)
  }
}

pub fn parse(
  contents: String,
) -> Result(#(String, List(Element(a)), Int), MetadataError) {
  use #(meta, contents) <- result.try(extract_metadata(contents))
  let #(parsed, count) = parse_body(contents)
  Ok(#(meta, parsed, count))
}

@external(javascript, "./markdown.ffi.mjs", "parseMarkdown")
fn parse_body(content: String) -> #(List(Element(a)), Int) {
  todo
}
