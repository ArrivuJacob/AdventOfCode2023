defmodule Day05 do
  @path "../../Assets/day05-trim.txt"

  def puzzle1 do
    {seeds, maps} = load_file()
    seeds
    |>Enum.map(fn seed ->
      maps
      |>Enum.reduce(seed, fn(map, acc) -> calculate_mapped_value(map,acc) end)
    end)
    |>Enum.min()
  end

  #this is super slow
  def puzzle2_slow do
    {seeds, maps} = load_file()
    divisi = 20
    divisi_range = Enum.to_list(0..divisi-1)
    seeds
    |>Enum.chunk_every(2)
    |>Enum.map(fn [start,range] ->
      chunk_size = div(range,divisi)
      chunk_rem = rem(range,divisi)
      divisi_range
      |>Enum.map(fn x ->
        cond do
          x < divisi - 1 -> [start + (chunk_size * x),chunk_size - 1]
          x == divisi - 1 -> [start + (chunk_size * x),chunk_size - 1 + chunk_rem]
        end
       end)
    end)
    |>Enum.concat()
    |>Enum.map(fn [start, range] ->
      seed_range = Enum.to_list(start..(start + range - 1))
      seed_range
      |>Enum.map(fn seed ->
        maps
        |>Enum.reduce(seed, fn(map, acc) -> calculate_mapped_value(map,acc) end)
      end)
    end)
    |>Enum.min()
  end

  def puzzle2_fast do
    {seeds, maps} = load_file()
    maps = maps|>Enum.map(fn x -> x|>Enum.sort_by(fn [_,x,_] -> x end) end)
    seeds
    |>Enum.chunk_every(2)
    |>Enum.map(fn [start, range] -> start..(start + range - 1) end)
    |>Enum.map(fn seed ->
      seed
    #  |>Enum.reduce( :infinity, fn)
    end)
    #|>Enum.map(fn [start, range] ->
    #  maps
    #  |>Enum.map(fn map ->
    #    overlapped_map = find_overlaps(map, start, range)
    #    calculate_mapped_range(overlapped_map, start, range) end)
    #end)
  end

  #def puzzle2_fast_reversal do
  #  {seeds, maps} = load_file()
  #  seeds = seeds|>Enum.chunk_every(2)|>Enum.sort_by(fn [x,_] -> x end)
  #  maps = maps
  #  |>Enum.reverse()
  #  |>Enum.map(fn x -> x|>Enum.sort_by(fn [x,_,_] -> x end)end)
  #  [first_reversed|rest] = maps
  #  first_reversed
  #  |>Enum.reduce_while([],fn row, acc ->
  #    final_row = find_the_lowest_link(rest, row)
  #    seed = seed_exist(final_row, seeds)
  #    if seed != nil do
  #      {:halt, [seed,row]}
  #    else
  #      {:cont, []}
  #    end
  #  end)
  #end

  defp load_file do
    {:ok, input} = File.read(@path)
    [seeds|rest] = input|>String.split("\n\n",trim: true)
    seeds = seeds|> String.split(["seeds: ", " "], trim: true)|> Enum.map(&String.to_integer/1)
    maps =
      rest
      |>Enum.map(fn map ->
        [_|rest] =
          map
          |>String.split([":","\n"], trim: true)
        rest
        |>Enum.map(fn row ->
          row|>String.split(" ", trim: true)|> Enum.map(&String.to_integer/1)
        end)
      end)
    {seeds, maps}
  end



  #defp find_the_lowest_link(maps, row) do
  #  [_,source, range] = row
  #  [first_reversed|rest] = maps
  #  found_overlaps = first_reversed|>Enum.filter(fn [nxt_dest, nxt_source, nxt_range] ->
  #    !Range.disjoint?(nxt_dest..nxt_dest+nxt_range-1, source..source+range-1)
  #  end)
  #  counts = Enum.count(found_overlaps)
  #  if counts < 0 do
  #    find_the_lowest_link(rest, [_,source,range])
  #  else
  #    splits = found_overlaps|>Enum.map(fn overlap ->

  #    end)
  #  end
  #end

  defp find_the_lowest_link([], row) do
    [row]
  end

  defp seed_exist([_,source,range],seeds) do
    seed = seeds|>Enum.find(fn [seed_start,seed_range] ->
      !Range.disjoint?(seed_start..seed_start+seed_range-1, source..source+range-1)
    end)
    seed
  end

  #defp calculate_mapped_range(overlap_map, start, range) do
    #overlap_map.
  #end

  defp calculate_mapped_range(_, _, 0) do
    :ok
  end

  defp find_overlaps(map, start, range) do
    map
    |>Enum.map(fn row ->
      [_,source,map_range] = row
      is_overlap_lead = within_range(start, range, source)
      is_overlap_trail = within_range(start, range, source+map_range-1)
      [row,[is_overlap_lead,is_overlap_trail]]
    end)
    |>Enum.filter(fn [_,overlap] ->
      [is_overlap_lead,is_overlap_trail] = overlap
      is_overlap_lead || is_overlap_trail
    end)
  end



  defp destination_range_balance(map_range,source_range) do
    cond do
      map_range >= source_range -> {source_range, 0}
      map_range < source_range -> {map_range,source_range - map_range}
    end
  end

  defp calculate_mapped_value(map, input) do
    filtered_map = map
    |>Enum.filter(fn [_, source, range] -> within_range(source, range, input) end)
    map_count = Enum.count(filtered_map)
    cond do
      map_count > 0 ->
        [[dest, source, _]|_] = filtered_map
        dest = dest + (input - source)
        dest
      map_count == 0 ->
        input
    end

  end

  defp within_range(start, range, input) do
    if start<= input && input < (start + range) do
      true
    else
      false
    end
  end

end
