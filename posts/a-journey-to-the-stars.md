---
id = "a-journey-to-the-star"
slug = "a-journey-to-the-stars"
title = "💫 A Journey to the Stars"
abstract = "In the world of programming language, the functional family of language tends to stand out because of the way unmistakably different style programs end up being written in. Although most languages espouse some form of 'functional style', e.g. with functions such as map, filter and reduce, the 'true' functional programming language commit to that style 100%. In this post, I discuss an exciting and relatively new programming language called Gleam, which have caught my eye and peaked my interest, so much that I've decided to start a few projects in it!"
tags = ["Gleam"]
publication_date = "2024-08-22"
draft = false
---

After working with Python for years, I wanted to diversify a little bit and
explore something else, something different, refreshing. For a while, I thought
about spending some time with [Go](https://go.dev/), which is an excellent
language from writing back-end servers, thanks to its overall simplicity and
amazing concurrency model. But in March of this year, an exciting new language
released in its 1.0 version: 💫 [Gleam](https://gleam.run/news/gleam-version-1/)
💫.

Gleam is, like Go, a simple language, as one of its main objective was to avoid
"magic" and generally provide one way of doing things. This is a great goal,
which inherently makes Gleam a polar opposite of Python!

Another way that Gleam differs systematically from Python, is that it is
**statically typed**, with a wonderful type system to boot. This means that, in
general, if a program compiles, then it will run, and runtime errors will be much
rarer when compared to an equivalent program written in Python or Javascript.

But where Gleam shines above all for me, can be summarized in one word:

> **Aesthetics**.

First, look at their [website](https://gleam.run):

![](/images/gleam_website_banner.png)

If you're not convinced, let's take a look at the gorgeous code. Don't worry
if it looks foreign, it's mostly due to the _functional style_ of the language, and
we will go over these features in the next sections and future posts.

```gleam
/// Source:
/// https://github.com/giacomocavalieri/squirrel/blob/main/src/squirrel.gleam

fn run(
  directories: Dict(String, List(String)),
  connection: postgres.ConnectionOptions,
) -> Dict(String, #(Int, List(Error))) {
  use directory, files <- dict.map_values(directories)

  let #(queries, errors) =
    list.map(files, query.from_file)
    |> result.partition

  let #(queries, errors) = case postgres.main(queries, connection) {
    Error(error) -> #([], [error, ..errors])
    Ok(#(queries, type_errors)) -> #(queries, list.append(errors, type_errors))
  }

  let output_file =
    filepath.directory_name(directory)
    |> filepath.join("sql.gleam")

  case write_queries(queries, to: output_file) {
    Ok(n) -> #(n, errors)
    Error(error) -> #(list.length(queries), [error, ..errors])
  }
}
```

## A quick Gleam overview

Because it is a functional programming language, writing Gleam is quite
different from writing in other languages, such as Python, as it has (almost)
**none of the usual control flow mechanisms** (e.g. loops and conditionals).
What Gleam has, however, is:

- **Recursion** (which is our go-to mechanism to replace iteration); and
- **Pattern matching**.

Consider the following simple Python program:

```python
def integers_above_n(lst: list[int], n: float) -> list[int]:
    return [
        item
        for item in lst
        if item > n
    ]
```

In Gleam, a naive implementation of this function would look like:

```gleam
import gleam/int

fn integers_above_n(lst: List(Int), n: Float) -> List(Int) {
  case lst {
    [] -> lst
    [first, ..rest] -> {
      case int.to_float(first) >. n {
        True -> [first, ..integers_above_n(rest, n)]
        False -> integers_above_n(rest, n)
      }
    }
  }
}
```

> _You may wonder why I've chosen to write the Python implementation to return a new list rather than mutate the original list. This is because variables are all immutable in Gleam, as it is usual for functional languages._
>
> _While it takes some time to get used to it, the lack of mutability ultimately makes the code easier to understand, as the scope in which a variable can change is very limited (i.e. within a function)._

Let's break down what the function does, although it is probably quite clear:

- Gleam doesn't have a `return` statement. Instead, it uses **implicit returns**
  , and the last line of a block is what is going to be returned out of the block.
  As such, the result of the `case` statement is the return value of our function.

- The `case` statement does a pattern match on our list `list`.

  - `[] -> lst` means that if the list is empty, we return the list itself (i.e. we are done iterating);
  - If the list is not empty, the the list can be written as
    `[first, ..rest]`, i.e. `first` is the name we attach to the first element
    of the list, and the rest of the list is labelled `rest`. We write it as `..rest` because `rest` is itself a list. This would be the equivalent of
    writing `*rest` in Python.

    In this case, we need to consider two cases for the value of `first`.

    - If it is above `n`, we add it to our output;
    - Otherwise, we skip it.

    Of course, because Gleam makes us write **type-safe** programs, we cannot
    directly compare integers and floating numbers, so we have to make a conversion
    before the comparison (and note the dedicated comparison operators for floating
    numbers `>.` to make everything explicit.)

This example represents well the type of control flows you can expect from Gleam
programs. Even though I find it quite easy to read, one could argue that it is
a little bit verbose, and that Python's list comprehension reads a little bit
nicer.

Fret not, because there is a much more idiomatic way to write this function:

```gleam
import gleam/list

fn integers_above_n(lst: List(Int), n: Float) -> List(Int) {
  list.filter(lst, fn(x) { int.to_float(x) >. n })
}
```

This code performs the filtering of the list, using an **anonymous function** as
a way to decide which elements should be retained (in our case, the values that
are greater than `n`.)

Now let us imagine we wanted to return **the square** of all the values above 5.
We could use the `list.map` function, which applies a function to each element
of a list, which then would give:

```gleam
import gleam/list

fn square_of_integers_above_n(lst: List(Int), n: Float) -> List(Int) {
  list.map(list.filter(lst, fn(x) { int.to_float(x) >. n }), fn(x) { x * x })
}

```

Now this is quite difficult to read, especially when compared to its Python
equivalent, i.e.

```python
def square_of_integers_above_n(lst: list[int], n: float) -> list[int]:
    return [
        item * item
        for item in lst
        if item > n
    ]
```

Because Gleam is built upon functions, it gives us some syntactic sugar to help
us write chains of functions. In our case above, what we want to do is provide
the `list.map` function with the result of the `list.filter` function. This can
be done using the **pipe** operator `|>`:

```gleam
import gleam/list

fn square_of_integers_above_n(lst: List(Int), n: Float) -> List(Int) {
  lst
  |> list.filter(fn(x) { int.to_float(x) >. n })
  |> list.map(fn(x) { x * x })
}
```

The pipe operator essentially works by using the value on the left as the
**first argument** in the function on the right. The Gleam syntax is great
because it allows us to specify the other arguments of that function.

## Uses for Gleam

Gleam is a **general purpose** programming language, which means it could
technically be used to write any kind of program.

Your Gleam code can compile to two different targets:

- [Erlang](https://www.erlang.org/); and
- [Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript),

which allows you to do two different things:

1. When compiling to Erlang, your code is going to run on the [BEAM virtual machine](<https://en.wikipedia.org/wiki/BEAM_(Erlang_virtual_machine)>),
   which enables Erlang's amazing concurrency model (the Open Telecom Platform, or "OTP" for short), used by the likes of WhatsApp.
2. You can compile your code to Javascript in order to build website front-ends, using a framework like [`lustre`](https://github.com/lustre-labs/lustre).

Armed with these two different targets, you could theoretically do anything!

For example, this blog is now written in Gleam (although a large part of the
logic for converting the posts to html elements was lifted from
[Giacomo Cavalieri's own blog](https://giacomocavalieri.me))!

Another good example is Gleam's excellent [Language Tour](https://tour.gleam.run/),
which, as far as I know, embed the Gleam compiler into the browser using WASM,
and compile's the user's code into Javascript to run it in the browser and
display the results in a snappy fashion (no need to send the code to a server
for compilation).

## Conclusion

Finally, I think the most important aspect in trying a new programming language
is that it should be **fun**. For me, the aesthetics of the language, coupled
with the functional style and the great type system (which I will discuss in the
next post), makes writing Gleam extremely fun, and that's why I will stick to it
for the foreseeable future, although I know my day job will remain very much
Python-based for a good while.

👋
