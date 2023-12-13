defmodule Day03 do
  @path "../../Assets/day03-input.txt"
  @not_symbol ~r/[^0-9.\r]/
  @direction [{-1,-1}, {0,-1}, {1, -1}, {-1,0}, {1,0}, {-1,1},{0,1},{1,1}]
  @numbers_regex ~r/(\d+)/
  @gear_regex ~r/[*]/

  #puzzle 1#
  def puzzle1 do
    input = load_file()
    input
    |>Enum.map(fn {row, idy} -> process_row(row, input, idy) end)
    |>Enum.sum()
  end

  defp process_row(row, data, idy) do
    row
    |> find_index_numbers()
    |> Enum.filter(fn {_, idxs} ->
      check_adjacent_symbol(data, idxs ,idy)
    end)
    |> Enum.map(fn {number, _, _} -> number end)
    |> Enum.sum()
  end

  defp check_adjacent_symbol(data, idxs, idy) do
    idxs
    |> Enum.any?(fn(idx) ->
      @direction
      |> Enum.any?(fn {dx,dy} ->
        case Enum.at(data, idy + dy) do
          {rows,_} ->
            elem = String.at(rows, idx + dx)
            String.match?(elem, @not_symbol)
          nil ->
            false
        end
      end)
    end)
  end

  #puzzle 2#
  def puzzle2 do
    input = load_file()
    numbers =
      input|>Enum.map(fn {row, idy} ->
        {row |> find_index_numbers(),idy}
      end)
    gears =
      input|>Enum.map(fn {row, idy} ->
        {row |> find_index_gear(),idy}
      end)
    find_gear_ratio(gears, numbers)
    |> Enum.map(fn x -> x|>Enum.sum() end)
    |> Enum.sum()
  end

  defp find_index_gear(row) do
    @gear_regex
    |>Regex.scan(row, return: :index)
    |>Enum.map(&List.first/1)
    |>Enum.map(fn {index, _} -> index end)
  end

  defp find_gear_ratio(gears, numbers) do
    gears
    |>Enum.map(fn {idxs, idy} ->
      idxs
      |> Enum.map(fn idx -> get_gear_index(Enum.slice(numbers, idy - 1, 3), idx) end)
    end)
  end

  defp get_gear_index(numbers, idx) do
    indexes = [-1,0,1] |> Enum.map(&(idx + &1))
    match_num = numbers
    |> Enum.map(fn {row,_} ->
      row
      |> Enum.filter(fn {_, num_indx} ->
        num_indx
        |> Enum.any?(fn num_i ->
          Enum.any?(indexes, fn i -> i == num_i end)
        end)
      end)
      |> Enum.map(fn {number, _} -> number end)
    end)
    |> Enum.flat_map(fn k -> k end)
    if length(match_num) >= 2 do
      match_num |> Enum.product()
    else
      0
    end
  end

  #Shared
  defp load_file() do
    {:ok, input} = File.read(@path)
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
  end

  defp find_index_numbers(row) do
    @numbers_regex
    |>Regex.scan(row, return: :index)
    |>Enum.map(&List.first/1)
    |>Enum.map(fn {index, length} ->
      last_index = index + length - 1
      {String.slice(row, index..last_index) |> String.to_integer(), Enum.to_list(index..last_index)}
    end)
  end

end
