defmodule AdventOfCode2018.Day06 do
  alias AdventOfCode2018.Utils

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 06](https://adventofcode.com/2018/day/6).
  """

  @doc """
  Get the area of the largest group of points in a plane
  grouped by being closest to a coordinate in `file`.

  Using the Manhattan Distance algorithm.
  """
  @spec part1(String.t()) :: integer()
  def part1(file) do
    points = get_points(file)

    {min_x, max_x, min_y, max_y} = get_min_max_points(points)

    perimeter_coords = build_perimeter(min_x, max_x, min_y, max_y) |> get_closest_points(points)

    {_, area} = build_area(min_x, max_x, min_y, max_y)
      |> get_closest_points(points)
      |> Enum.reduce(%{}, fn coord, acc -> Map.update(acc, coord, 1, &(&1 + 1)) end)
      |> Enum.reject(fn {coord, _} -> coord in perimeter_coords end)
      |> Enum.max_by(fn {_, area} -> area end)

    area
  end

  @doc """
  Get the number of points in a plane whose sum of distances
  to all coordinates in a `file` is less than `limit`.

  Using the Manhattan Distance algorithm.
  """
  @spec part2(String.t(), integer()) :: integer()
  def part2(file, limit) do
    points = get_points(file)

    {min_x, max_x, min_y, max_y} = get_min_max_points(points)

    build_area(min_x, max_x, min_y, max_y)
    |> Enum.map(fn coord ->
        Enum.reduce(points, 0, fn point, acc -> manhattan_distance(point, coord) + acc end)
      end)
    |> Enum.filter(&(&1 < limit))
    |> length()
  end

  defp get_points(file), do: file |> Utils.stream_lines() |> Enum.map(&parse_coords/1)

  defp get_min_max_points(points) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(points, fn {coord_x, _} -> coord_x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn {_, coord_y} -> coord_y end)
    {min_x, max_x, min_y, max_y}
  end

  defp parse_coords(line) do
    [coord_x, coord_y] = String.split(line, ", ")
    {String.to_integer(coord_x), String.to_integer(coord_y)}
  end

  defp build_area(min_x, max_x, min_y, max_y) do
    for coord_x <- min_x..max_x, coord_y <- min_y..max_y, do: {coord_x, coord_y}
  end

  defp build_perimeter(min_x, max_x, min_y, max_y) do
    edges_x = for c_x <- min_x..max_x, c_y <- [min_y, max_y], do: {c_x, c_y}
    edges_y = for c_y <- min_y..max_y, c_x <- [min_x, max_x], do: {c_x, c_y}
    Enum.concat(edges_x, edges_y)
  end

  defp get_closest_points(coords, points) do
    coords
    |> Enum.map(fn coord -> get_closest_of(coord, points) end)
    |> Enum.filter(&(&1))
  end

  defp get_closest_of(coord, points) do
    points
    |> Enum.map(fn point -> {point, manhattan_distance(point, coord)} end)
    |> get_min()
  end

  defp manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  defp get_min(coords) do
    {min_coord, min_distance} = Enum.min_by(coords, fn {_, distance} -> distance end)
    case Enum.count(coords, fn {_, count} -> count == min_distance end) do
      1 -> min_coord
      _ -> nil
    end
  end
end
