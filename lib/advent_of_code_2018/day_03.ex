defmodule AdventOfCode2018.Day03 do
  alias AdventOfCode2018.Utils

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 03](https://adventofcode.com/2018/day/3).
  """

  @doc """
  From a `file`, parse the data given of a set of "claims",
  and retrieve the number of overlapping points when ordered
  in a grid.
  """
  @spec part1(String.t()) :: integer()
  def part1(file) do
    file
    |> Utils.stream_lines()
    |> Stream.map(&parse/1)
    |> Stream.flat_map(&build_coords/1)
    |> Enum.reduce(Map.new(), fn coords, acc -> Map.update(acc, coords, 1, &(&1 + 1)) end)
    |> Enum.count(fn {_, count} -> count > 1 end)
  end

  @doc """
  Parse a set of claims and retrieve the ID
  of the only non-overlapping instance.
  """
  @spec part2(String.t()) :: String.t()
  def part2(file) do
    claims = file
      |> Utils.stream_lines()
      |> Stream.map(&parse/1)
      |> Stream.map(fn {id, _, _, _, _} = claim -> {id, MapSet.new(build_coords(claim))} end)
      |> Map.new()

    [{id, false}] = claims
      |> Stream.map(fn claim -> set_intersects?(claim, claims) end)
      |> Stream.filter(fn {_, result} -> !result end)
      |> Enum.to_list()

    id
  end

  defp parse(line) do
    ["#" <> id, "@", points, size] = String.split(line)
    [point_x, point_y] = points |> String.trim_trailing(":") |> String.split(",")
    [size_x, size_y] = String.split(size, "x")
    {id, String.to_integer(point_x), String.to_integer(point_y), String.to_integer(size_x), String.to_integer(size_y)}
  end

  defp build_coords({_, point_x, point_y, size_x, size_y}) do
    for coord_x <- (point_x + 1)..(point_x + size_x),
      coord_y <- (point_y + 1)..(point_y + size_y) do
      {coord_x, coord_y}
    end
  end

  defp set_intersects?({id, set}, claims) do
    number_intersections = Enum.map(claims, fn {_, claim_set} ->
        claim_set
        |> MapSet.intersection(set)
        |> Enum.empty?()
      end)
      |> Enum.count(fn intersection -> !intersection end)

    case number_intersections do
      1 -> {id, false}
      _ -> {id, true}
    end
  end
end
