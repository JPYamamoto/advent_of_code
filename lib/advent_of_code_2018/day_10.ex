defmodule AdventOfCode2018.Day10 do
  alias AdventOfCode2018.Utils

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 10](https://adventofcode.com/2018/day/10).
  """

  @doc """
  From a `file` with coordinates and their respective velocity,
  get the string representation of their location, when their
  area is the smallest.

  I consider the smallest area to be the one where more stars
  are overlapped, meaning the chance is higher that it has
  the message.
  """
  @spec part1(String.t()) :: String.t()
  def part1(file) do
    {coords, _} = coords_iter(file)
    print(coords)
  end

  @doc """
  Get the number of iterations (seconds) that it takes the
  points in the `file` to align to display a message, taking
  into account the velocity of each one of them.
  """
  @spec part2(String.t()) :: integer()
  def part2(file) do
    {_, iter} = coords_iter(file)
    iter
  end

  defp coords_iter(file) do
    coords = file |> Utils.stream_lines() |> Enum.map(&parse_points/1) 
    first_area = area_of(coords)
    tick({coords, []}, {first_area, first_area + 1}, 0)
  end

  defp parse_points("position=<" <> substring) do
    [p_x, p_y, v_x, v_y] = String.split(substring, ["> velocity=<", ",", ">", " "], trim: true)
    {String.to_integer(p_x), String.to_integer(p_y), String.to_integer(v_x), String.to_integer(v_y)}
  end

  defp tick({coords, _}, {new_area, last_area}, iter) when new_area < last_area do
    new_coords = Enum.map(coords, &relocate/1)
    tick({new_coords, coords}, {area_of(new_coords), new_area}, iter + 1)
  end
  defp tick({_, l_coords}, _, iter), do: {l_coords, iter - 1}

  defp relocate({pos_x, pos_y, vel_x, vel_y}), do: {pos_x + vel_x, pos_y + vel_y, vel_x, vel_y}

  defp area_of(coords) do
    {min_x, max_x, min_y, max_y} = min_max_of(coords)
    abs((max_x - min_x) * (max_y - min_y))
  end

  defp min_max_of(coords) do
    {{min_x, _, _, _}, {max_x, _, _, _}} = Enum.min_max_by(coords, fn {pos_x, _, _, _} -> pos_x end)
    {{_, min_y, _, _}, {_, max_y, _, _}} = Enum.min_max_by(coords, fn {_, pos_y, _, _} -> pos_y end)
    {min_x, max_x, min_y, max_y}
  end

  defp print(coords) do
    {min_x, max_x, min_y, max_y} = min_max_of(coords)
    print_point = fn
      true -> "#"
      false -> "."
    end

    for y <- min_y..max_y do
      Enum.map(min_x..max_x, fn x -> Enum.any?(coords, fn {pos_x, pos_y, _, _} -> pos_x == x and pos_y == y end) end)
    end
    |> Enum.map(&(Enum.map(&1, fn point -> print_point.(point) end)))
    |> Enum.map(&(Enum.join(&1 ++ ["\n"])))
    |> Enum.join()
  end
end
