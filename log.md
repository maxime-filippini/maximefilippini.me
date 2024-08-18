Writing my blog in Gleam

## Gleam

## Converting markdown file

Inspiration: [https://github.com/giacomocavalieri/giacomocavalieri.me/](https://github.com/giacomocavalieri/giacomocavalieri.me/)

It seems that Giacomo here uses a javascript library (`mdast-util-from-markdown`) to convert Markdown into an AST, and then uses `lustre` functions to build HTML from that AST.

I do some testing on that in the [testing/js] directory.

`mdast-util-from-markdown` provides a `fromMarkdown()` function that turns a markdown string into an AST.

Example from Giacomo's article:

```markdown
---
id = "a-new-gleam-feature-i-love"
title = "A new Gleam feature I love"
abstract = "A new Gleam release is right around the corner and it will come with a new feature I absolutely love: _label shorthands._ It might not be as flashy as other features but I wanted to implement it for the longest time and think it will really help me write better code. Here's what it's all about."
tags = ["gleam", "dx", "fp"]
date = "2024-07-26"
status = "show"
---

[Gleam](https://gleam.run) is a functional "friendly language for building
systems that scale". But if I had to describe it with a single word it would be
_simple._
Given the small number of features, one could probably go through the entire
[language tour](https://tour.gleam.run) in a couple of days and learn all there
is to the language.
This is intentional! Gleam's simplicity is also one of its key features;
as clichè as it may sound, sometimes less is more.
As [Rob Pike puts it](https://www.youtube.com/watch?v=rFejpH_tAHM)
_"Simplicity is complicated but the clarity is worth the fight."_
```

...becomes

```json
[
  {
    "type": "thematicBreak",
    "position": {
      "start": { "line": 1, "column": 1, "offset": 0 },
      "end": { "line": 1, "column": 4, "offset": 3 }
    }
  },
  {
    "type": "heading",
    "depth": 2,
    "children": [
      {
        "type": "text",
        "value": "id = \"a-new-gleam-feature-i-love\"\ntitle = \"A new Gleam feature I love\"\nabstract = \"A new Gleam release is right around the corner and it will come with a new feature I absolutely love: ",
        "position": {
          "start": { "line": 2, "column": 1, "offset": 4 },
          "end": { "line": 4, "column": 115, "offset": 189 }
        }
      },
      {
        "type": "emphasis",
        "children": [
          {
            "type": "text",
            "value": "label shorthands.",
            "position": {
              "start": { "line": 4, "column": 116, "offset": 190 },
              "end": { "line": 4, "column": 133, "offset": 207 }
            }
          }
        ],
        "position": {
          "start": { "line": 4, "column": 115, "offset": 189 },
          "end": { "line": 4, "column": 134, "offset": 208 }
        }
      },
      {
        "type": "text",
        "value": " It might not be as flashy as other features but I wanted to implement it for the longest time and think it will really help me write better code. Here's what it's all about.\"\ntags = [\"gleam\", \"dx\", \"fp\"]\ndate = \"2024-07-26\"\nstatus = \"show\"",
        "position": {
          "start": { "line": 4, "column": 134, "offset": 208 },
          "end": { "line": 7, "column": 16, "offset": 448 }
        }
      }
    ],
    "position": {
      "start": { "line": 2, "column": 1, "offset": 4 },
      "end": { "line": 8, "column": 4, "offset": 452 }
    }
  },
  {
    "type": "paragraph",
    "children": [
      {
        "type": "link",
        "title": null,
        "url": "https://gleam.run",
        "children": [
          {
            "type": "text",
            "value": "Gleam",
            "position": {
              "start": { "line": 10, "column": 2, "offset": 455 },
              "end": { "line": 10, "column": 7, "offset": 460 }
            }
          }
        ],
        "position": {
          "start": { "line": 10, "column": 1, "offset": 454 },
          "end": { "line": 10, "column": 27, "offset": 480 }
        }
      },
      {
        "type": "text",
        "value": " is a functional \"friendly language for building\nsystems that scale\". But if I had to describe it with a single word it would be\n",
        "position": {
          "start": { "line": 10, "column": 27, "offset": 480 },
          "end": { "line": 12, "column": 1, "offset": 609 }
        }
      },
      {
        "type": "emphasis",
        "children": [
          {
            "type": "text",
            "value": "simple.",
            "position": {
              "start": { "line": 12, "column": 2, "offset": 610 },
              "end": { "line": 12, "column": 9, "offset": 617 }
            }
          }
        ],
        "position": {
          "start": { "line": 12, "column": 1, "offset": 609 },
          "end": { "line": 12, "column": 10, "offset": 618 }
        }
      },
      {
        "type": "text",
        "value": "\nGiven the small number of features, one could probably go through the entire\n",
        "position": {
          "start": { "line": 12, "column": 10, "offset": 618 },
          "end": { "line": 14, "column": 1, "offset": 696 }
        }
      },
      {
        "type": "link",
        "title": null,
        "url": "https://tour.gleam.run",
        "children": [
          {
            "type": "text",
            "value": "language tour",
            "position": {
              "start": { "line": 14, "column": 2, "offset": 697 },
              "end": { "line": 14, "column": 15, "offset": 710 }
            }
          }
        ],
        "position": {
          "start": { "line": 14, "column": 1, "offset": 696 },
          "end": { "line": 14, "column": 40, "offset": 735 }
        }
      },
      {
        "type": "text",
        "value": " in a couple of days and learn all there\nis to the language.\nThis is intentional! Gleam's simplicity is also one of its key features;\nas clichè as it may sound, sometimes less is more.\nAs ",
        "position": {
          "start": { "line": 14, "column": 40, "offset": 735 },
          "end": { "line": 18, "column": 4, "offset": 923 }
        }
      },
      {
        "type": "link",
        "title": null,
        "url": "https://www.youtube.com/watch?v=rFejpH_tAHM",
        "children": [
          {
            "type": "text",
            "value": "Rob Pike puts it",
            "position": {
              "start": { "line": 18, "column": 5, "offset": 924 },
              "end": { "line": 18, "column": 21, "offset": 940 }
            }
          }
        ],
        "position": {
          "start": { "line": 18, "column": 4, "offset": 923 },
          "end": { "line": 18, "column": 67, "offset": 986 }
        }
      },
      {
        "type": "text",
        "value": "\n",
        "position": {
          "start": { "line": 18, "column": 67, "offset": 986 },
          "end": { "line": 19, "column": 1, "offset": 987 }
        }
      },
      {
        "type": "emphasis",
        "children": [
          {
            "type": "text",
            "value": "\"Simplicity is complicated but the clarity is worth the fight.\"",
            "position": {
              "start": { "line": 19, "column": 2, "offset": 988 },
              "end": { "line": 19, "column": 65, "offset": 1051 }
            }
          }
        ],
        "position": {
          "start": { "line": 19, "column": 1, "offset": 987 },
          "end": { "line": 19, "column": 66, "offset": 1052 }
        }
      }
    ],
    "position": {
      "start": { "line": 10, "column": 1, "offset": 454 },
      "end": { "line": 19, "column": 66, "offset": 1052 }
    }
  }
]
```

My understanding of how it works is the following:

- [src/markdown.ffi.mjs] calls functions from [./markdown/ffi_builders.mjs], but this `ffi_builders` file is not a javascript file, it's a gleam file.
- As such, I assume that `ffi_builders` contains a set of Gleam functions which get turned into js functions when compiled with that target, and can therefore be called within an ffi file, which then can be used within Gleam.

Let us try to test this theory.

We start by creating a `.gleam` file that implements a simple function:

```gleam ffi_builder.gleam
pub fn my_test_function(s: String) -> String {
  s <> " from my_test_function"
}
```

This function can be imported within a javascript module, i.e.

```js test_ffi.mjs
import * as GleamFFI from "./ffi_builder.mjs";

export function test_ffi(s) {
  return GleamFFI.my_test_function(s);
}
```

And in our main gleam file:

```gleam ffis.gleam
import gleam/io

@external(javascript, "./test_ffi.mjs", "test_ffi")
fn call_ffi(content: String) -> String {
  todo
}

pub fn main() {
  io.println(call_ffi("hello"))
}

// hello from my_test_function
```

As we can see, the `gleam -> js -> gleam` flow works well here.

Note: `mdast` cannot find the language of a code block if that code block is indented.

## Plan
