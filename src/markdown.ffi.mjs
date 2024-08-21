import { Empty, NonEmpty } from "./gleam.mjs";
import { fromMarkdown } from "mdast-util-from-markdown";
import * as Markdown from "./markdown/ffi_functions.mjs";

const empty = new Empty();

// arr is an array of nodes
// we convert each node into an array [nodes, count]

const fold_into_list = (arr, f) =>
  // arr: [node, ...]
  // f: func(node) -> Element
  // val: node
  // acc: [[node, ...], count)

  // the arr is a list of either lists or single elements
  // the function passed to reduce can handle both
  arr.reduceRight(
    (acc, val) => {
      let [elt, count] = f(val); // [[Element], int]

      if (elt === undefined) {
        return acc;
      }

      return [new NonEmpty(elt, acc[0]), acc[1] + count];
    },
    [empty, 0]
  );

export function parseMarkdown(contents) {
  const ast = fromMarkdown(contents);

  return fold_into_list(ast.children, function to_lustre_element(node) {
    switch (node.type) {
      case "code":
        return Markdown.code(node.value, node.lang);
      case "image":
        return Markdown.image(node.url, node.alt);
      case "emphasis":
        return Markdown.emphasis(
          fold_into_list(node.children, to_lustre_element)
        );
      case "inlineCode":
        return Markdown.inline_code(node.value);
      case "link":
        return Markdown.link(
          node.url,
          fold_into_list(node.children, to_lustre_element)
        );
      case "list":
        return Markdown.list(
          !!node.ordered,
          fold_into_list(node.children, to_lustre_element)
        );
      case "listItem":
        return Markdown.list_item(
          fold_into_list(node.children, to_lustre_element)
        );
      case "paragraph":
        return Markdown.paragraph(
          fold_into_list(node.children, to_lustre_element)
        );
      case "strong":
        return Markdown.strong(
          fold_into_list(node.children, to_lustre_element)
        );
      case "text":
        return Markdown.text(node.value);
      case "blockquote":
        return Markdown.blockquote(
          fold_into_list(node.children, to_lustre_element)
        );
      case "thematicBreak":
        return Markdown.thematic_break();
      case "heading":
        return Markdown.heading(node.depth, node.children[0].value);
      default:
        return [undefined, 0]; // skip
    }
  });
}
