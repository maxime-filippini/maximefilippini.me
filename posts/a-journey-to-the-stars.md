---
id = "a-journey-to-the-star"
slug = "a-journey-to-the-stars"
title = "💫 A Journey to the Stars"
abstract = ""
tags = ["Gleam"]
publication_date = "2024-08-22"
draft = true
---

```
- intro to gleam
- sum types
- pattern matching, no loops, no ifs
- steps in writing a static site in gleam
- coolify
```

In programming as with everything, we ought to try to make an effort to "_choose
the best tool for the job_", from our development environment to our programming
language. However, for most applications, the notion of what would constitute
an appropriate programming language for a given task has grown to encompass
more aspects than simply **performance**, e.g.

- Ease of development and prototyping ("_developer experience_");
- Familiarity of the developers with the language;
- Standard library and third-party ecosystem;
- Runtime robustness.

**Python** is a prime example of a language whose performance can leave to be
desired, but thanks to simple syntax, sprawling third-party libraries and access
to higher performance via interoperability with C, has become the language of
choice for many professionals.

Although I tend to speak and write about Python primarily, as it is the language
I use the most, this post is about a new and exciting language called **Gleam**,
<span class="text-3xl">test</span>

## What is Gleam?

Gleam is a **statically typed**, **functional** programming language that
strives to be both **simple** and **friendly**. Its inherent simplicity comes
from the fact that Gleam's syntax has a very small surface area, with only a few
keywords.

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
