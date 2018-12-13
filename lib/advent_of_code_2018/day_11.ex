defmodule AdventOfCode2018.Day11 do
  def part1(grid_sn), do: grid_sn |> summed_areas_table() |> best_of(3) |> max_of() |> print()

  defp summed_areas_table(grid_sn) do
    Enum.reduce(1..300, %{}, fn y, table ->
      Enum.reduce(1..300, table, fn x, table_acc ->
        pointA = fuel_of({x, y}, grid_sn)
        pointB = Map.get(table_acc, {x, y - 1}, 0)
        pointC = Map.get(table_acc, {x - 1, y}, 0)
        pointD = Map.get(table_acc, {x - 1, y - 1}, 0)
        
        Map.put(table_acc, {x, y}, pointA + pointB + pointC - pointD)
      end)
    end)
  end

  defp fuel_of({x, y}, grid_sn) do
    rack_id = x + 10
    level = ((rack_id * y) + grid_sn) * rack_id
    level = hundred_digit(level) || 0
    level - 5
  end

  defp hundred_digit(number), do: number |> Integer.to_string() |> String.at(-3) |> String.to_integer()

  defp best_of(cells, size), do: for x <- 1..(300 - size + 1), y <- 1..(300 - size + 1), do: area_of({x, y}, size, cells)

  defp area_of({x, y}, size, cells) do
    pointA = Map.get(cells, {x - 1, y - 1}, 0)
    pointB = Map.get(cells, {x + size - 1, y - 1}, 0)
    pointC = Map.get(cells, {x - 1, y + size - 1}, 0)
    pointD = Map.get(cells, {x + size - 1, y + size - 1}, 0)
    {{x, y, size}, pointD - pointB - pointC + pointA}
  end

  defp max_of(cells), do: Enum.max_by(cells, fn {_, level} -> level end)

  defp print({{x, y, _}, _}), do: "#{x},#{y}"
  defp print({{x, y, size}, _}, :include_size), do: "#{x},#{y},#{size}"

  defp all_sizes_grid(cells), do: for size <- 1..300, do: best_of(cells, size) |> max_of()

  def part2(grid_sn), do: grid_sn |> summed_areas_table() |> all_sizes_grid() |> max_of() |> print(:include_size)
end
