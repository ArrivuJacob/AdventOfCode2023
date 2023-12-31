defmodule Day07 do
  @path "../../Assets/day07-trim.txt"

  def puzzle1 do
    data = load_file()
    data = data|>Enum.map(fn [hand,bid] ->
      hand_grouped = hand|>Enum.frequencies()
      [hand,bid,hand_grouped]
    end)
    |>sort_by(fn [_,_,grouped] ->
    end)
  end


  defp load_file do
    {:ok, input} = File.read(@path)
    input
    |>String.split("\n", trim: true)
    |>Enum.map(fn x ->
      [hand,bid] = String.split(x," ", trim: true)
      hand = hand
      |>String.graphemes()
      |>Enum.map(fn
        "A" -> 14
        "K" -> 13
        "Q" -> 12
        "J" -> 11
        "T" -> 10
        x -> String.to_integer(x)
      end)
      bid = String.to_integer(bid)
      [hand,bid]
     end)
  end
end
