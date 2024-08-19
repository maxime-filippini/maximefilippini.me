import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/int
import gleam/result
import gleam/string

pub type Month {
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December
}

pub type Date {
  Date(day: Int, month: Month, year: Int)
}

pub fn month_to_string(month: Month) -> String {
  case month {
    January -> "january"
    February -> "february"
    March -> "march"
    April -> "april"
    May -> "may"
    June -> "june"
    July -> "july"
    August -> "august"
    September -> "september"
    October -> "october"
    November -> "november"
    December -> "december"
  }
}

pub fn month_to_int(month: Month) -> Int {
  case month {
    January -> 1
    February -> 2
    March -> 3
    April -> 4
    May -> 5
    June -> 6
    July -> 7
    August -> 8
    September -> 9
    October -> 10
    November -> 11
    December -> 12
  }
}

fn month_from_int(int: Int) -> Result(Month, Nil) {
  case int {
    1 -> Ok(January)
    2 -> Ok(February)
    3 -> Ok(March)
    4 -> Ok(April)
    5 -> Ok(May)
    6 -> Ok(June)
    7 -> Ok(July)
    8 -> Ok(August)
    9 -> Ok(September)
    10 -> Ok(October)
    11 -> Ok(November)
    12 -> Ok(December)
    _ -> Error(Nil)
  }
}

pub fn decoder(value: Dynamic) -> Result(Date, List(DecodeError)) {
  // Try to decode the string
  use str <- result.try(dynamic.string(value))

  let components = string.split(str, on: "-")

  let date = case components {
    [year, month, day] -> {
      use year <- result.try(int.parse(year))
      use day <- result.try(int.parse(day))
      use month_str <- result.try(int.parse(month))
      use month <- result.try(month_from_int(month_str))
      Ok(Date(year:, month:, day:))
    }
    _ -> Error(Nil)
  }

  date
  |> result.replace_error([
    dynamic.DecodeError(expected: "A date", found: "Something else", path: []),
  ])
}
