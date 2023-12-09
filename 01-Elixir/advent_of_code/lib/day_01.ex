defmodule Day01 do

  def puzzle1 do
    path = "../../Assets/day01-input.txt"
    {:ok, input} = File.read(path)
    input
    |> String.split("\n", trim: true)
    #|> Enum.reduce(0, fn x, acc -> x + acc end)
    |> Enum.reduce(0, fn (x, acc) -> extract_first_last_number(x) + acc end)
    #|> Enum.reduce(0, &(&1 + &2))
  end

  def puzzle2 do
    path = "../../Assets/day01-input.txt"
    {:ok, input} = File.read(path)
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&replace_string/1)
    |> Enum.reduce(0, fn (x, acc) -> extract_first_last_number(x) + acc end)
  end

  def extract_first_last_number(input) do
    first = input |> String.graphemes() |> Enum.find(0, &integer_parse_check/1)
    last = String.reverse(input) |> String.graphemes() |> Enum.find(0, &integer_parse_check/1)
    {x, _} = Integer.parse(first <> last)
    x
  end

  def replace_string("one" <> rest), do: "1" <> replace_string("e" <> rest)
  def replace_string("two" <> rest), do: "2" <> replace_string("o" <> rest)
  def replace_string("three" <> rest), do: "3" <> replace_string("e" <> rest)
  def replace_string("four" <> rest), do: "4" <> replace_string("r" <> rest)
  def replace_string("five" <> rest), do: "5" <> replace_string("e" <> rest)
  def replace_string("six" <> rest), do: "6" <> replace_string("x" <> rest)
  def replace_string("seven" <> rest), do: "7" <> replace_string("n" <> rest)
  def replace_string("eight" <> rest), do: "8" <> replace_string("t" <> rest)
  def replace_string("nine" <> rest), do: "9" <> replace_string("e" <> rest)
  def replace_string(<<char, rest::binary>>), do: <<char>> <> replace_string(rest)
  def replace_string(""), do: ""

  def integer_parse_check(input) do
    case Integer.parse(input) do
      {_, ""} -> true
      _ -> false
    end
  end

end
