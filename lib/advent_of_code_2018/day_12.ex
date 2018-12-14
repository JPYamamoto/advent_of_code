defmodule AdventOfCode2018.Day12 do
  alias AdventOfCode2018.Utils

  @generations 50_000_000_000
  @stability_at 200

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 12](https://adventofcode.com/2018/day/12).
  """

  @doc """
  From an initial input and a set of rules to follow (both
  given in `file`), get the value that the sum of the indexes
  of the pots will have after 20 days.
  """
  @spec part1(Strint.t()) :: integer()
  def part1(file) do
    file
    |> parse()
    |> next_n_generations(20)
    |> add_pots()
  end

  @doc """
  From an initial input and a set of rules to follow (both
  given in `file`), get the value that the sum of the indexes
  of the pots will have after 50_000_000_000 days.

  Find the stability of the execution and use that to
  calculate the final result.
  """
  @spec part1(String.t()) :: integer()
  def part2(file) do
    file
    |> parse()
    |> find_pattern(0, 0)
    |> calculate_result()
  end

  defp parse(file), do: file |> Utils.stream_lines() |> Enum.reduce({nil, MapSet.new()}, &parse_line/2)

  defp parse_line("initial state: " <> rest, {_, acc}) do
    plants = rest
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {plant?, _} -> plant? == "#" end)
      |> Enum.reduce(MapSet.new(), fn {_, index}, acc -> MapSet.put(acc, index) end)
    {plants, acc}
  end
  defp parse_line(<<rule :: binary-size(5), " => #">>, {state, rules}) do
    parsed_rule = rule |> String.graphemes() |> Enum.map(&(match?("#", &1)))
    {state, MapSet.put(rules, parsed_rule)}
  end
  defp parse_line(_, acc), do: acc

  defp next_n_generations({pots, rules}, times) do
    Enum.reduce(1..times, {pots, rules}, fn _, {state, _} -> {next_generation({state, rules}), rules} end)
  end

  defp next_generation({state, rules}) do
    {min, max} = Enum.min_max(state)

    (min - 5)..(max + 5)
    |> Enum.chunk_every(5, 1, :discard)
    |> Enum.filter(fn indices ->
        pattern = Enum.map(indices, fn index -> MapSet.member?(state, index) end)
        MapSet.member?(rules, pattern)
      end)
    |> Enum.map(fn indices -> Enum.at(indices, 2) end)
    |> MapSet.new()
  end

  defp add_pots({pots, _}), do: pots |> MapSet.to_list() |> Enum.sum()

  defp find_pattern({_, rules} = data, prev_val, @stability_at) do
    next_gen = next_generation(data)
    value_pots = add_pots({next_gen, rules})
    {@stability_at, value_pots, value_pots - prev_val}
  end
  defp find_pattern({_, rules} = data, _, iter) do
    next_gen = next_generation(data)
    find_pattern({next_gen, rules}, add_pots({next_gen, rules}), iter + 1)
  end

  defp calculate_result({iter, val, increment}), do: (@generations - iter - 1) * increment + val
end
