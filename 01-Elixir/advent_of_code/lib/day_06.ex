defmodule Day06 do
  @path "../../Assets/day06-input.txt"

  def puzzle1 do
    [time,distance] = load()
    data = Enum.zip(time,distance)
    data|>Enum.map(fn {t, d} ->
      find_total_way(t,d)
    end)
    |>Enum.product()
  end

  def puzzle2 do
    [time,distance] = load()
    time = time|>Enum.join()|>String.to_integer()
    distance = distance|>Enum.join()|>String.to_integer()
    find_total_way(time,distance)
  end

  defp find_total_way(time,distance) do
    Enum.filter(1..time-1, fn t -> distance < (time-t)*t end)
    |>Enum.count()
  end

  defp load do
    {:ok, input} = File.read(@path)
    [time, distance] = input
    |> String.split("\n", trim: true)
    time = time|> String.split(["Time:"," "], trim: true)|>Enum.map(&String.to_integer/1)
    distance = distance|> String.split(["Distance:"," "], trim: true)|>Enum.map(&String.to_integer/1)
    [time,distance]
  end
end
