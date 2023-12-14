defmodule Day04 do
  @path "../../Assets/day04-input.txt"

  def puzzle1 do
    input = load_file()
    input
    |>String.split("\n", trim: true)
    |>Enum.map(fn x ->
      [_, numbers ] = x|>String.split(":",trim: true)
      [result,taken] =
        numbers
        |>String.split("|",trim: true)
        |>Enum.map(&String.split/1)
        |>Enum.map(&MapSet.new/1)
        MapSet.intersection(result,taken)
        |>MapSet.size()
    end)
    |>Enum.filter(fn x -> x > 0 end)
    |>Enum.map(fn x ->
      :math.pow(2,x-1)
    end)
    |>Enum.sum()
  end

  def puzzle2 do
    input = load_file()
    result = input
    |>String.split("\n", trim: true)
    |>Enum.map(fn x ->
      [_, numbers ] = x|>String.split(":",trim: true)
      [result,taken] =
        numbers
        |>String.split("|",trim: true)
        |>Enum.map(&String.split/1)
        |>Enum.map(&MapSet.new/1)
        MapSet.intersection(result,taken)
        |>MapSet.size()
    end)
    |>Enum.with_index()
    get_card_counts(result, result)
    #result
  end

  defp get_card_counts(winning_list, full_list) do
    extendedCount = winning_list
    |> Enum.map(fn {number,idx} ->
      new_winning_list = full_list |> Enum.slice(idx+1, number)
      get_card_counts(new_winning_list, full_list)
    end)
    |>Enum.sum()

    Enum.count(winning_list) + extendedCount
  end

  defp load_file() do
    {:ok, input} = File.read(@path)
    input
  end
end
