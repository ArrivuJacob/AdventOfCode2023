defmodule Day02 do
  @path "../../Assets/day02-input.txt"
  @red 12
  @green 13
  @blue 14

  def puzzle1 do
    {:ok, input} = File.read(@path)
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {_, cubesHand} ->
      cubesHand
      |> Enum.all?(fn cubes ->
        red = !Map.has_key?(cubes, :red) || cubes.red <= @red
        green = !Map.has_key?(cubes, :green) || cubes.green <= @green
        blue = !Map.has_key?(cubes, :blue) || cubes.blue <= @blue
        red && green && blue
        end)
    end)
    |> Enum.map(fn {game, _} -> game end)
    |> Enum.sum()
  end

  def puzzle2 do
    {:ok, input} = File.read(@path)
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {_, cubesHand} ->
        cubesHand
        |> Enum.flat_map(fn k -> Map.to_list(k) end)
        |> Enum.group_by(fn {k,_} -> k  end, fn {_, v} -> v end)
        |> Enum.reduce(1, fn({_,v}, acc) -> Enum.max(v) * acc end)
      end)
    |> Enum.sum()
  end

  def parse_line(input) do
    [game, cubes] = input |> String.split(":")
    game = game|> String.replace_prefix("Game ","") |> String.to_integer()
    cubes = cubes|> String.split(";", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn y ->
        [count, colour] = String.split(y, " ", trim: true)
        {String.to_atom(colour), String.to_integer(count)}
         end)
      |> Enum.into(%{})
      end)
    {game, cubes}
  end

end
