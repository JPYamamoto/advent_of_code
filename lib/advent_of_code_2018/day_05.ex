defmodule AdventOfCode2018.Day05 do
  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 05](https://adventofcode.com/2018/day/5).
  """

  @char_diff ?a - ?A

  @doc """
  From a chain of polymers, get the length of
  the chain, after polymers have reacted.

  A reaction of polymers occurs when a
  lower-case char is followed by its
  upper-case version, in any order.

  When a reaction happens, both polymers
  involved are removed from the chain.
  """
  @spec part1(String.t()) :: integer()
  def part1(file) do
    file
    |> get_polymers()
    |> polymer_react()
    |> length()
  end

  @doc """
  From a chain of polymers, get the length of
  the shortest possible reacted chain, after
  a pair of lower-case and upper-case polymers
  have been removed from the original chain.
  """
  @spec part2(String.t()) :: integer()
  def part2(file) do
    chain = get_polymers(file)

    ?A..?Z
    |> Enum.map(&(react_removing_unit(&1, chain)))
    |> Enum.min()
  end

  defp get_polymers(file_path) do
    file = Path.join(:code.priv_dir(:advent_of_code_2018), file_path)

    file
    |> File.read!()
    |> String.trim_trailing()
    |> String.to_charlist()
  end

  defp polymer_react(polymers), do: Enum.reduce(polymers, [], &do_polymer_react/2)

  defp do_polymer_react(char, []), do: [char | []]
  defp do_polymer_react(char, [char | _] = acc), do: [char | acc]
  defp do_polymer_react(char, [l_char | rest]) when (l_char - @char_diff == char), do: rest
  defp do_polymer_react(char, [l_char | rest]) when (char - @char_diff == l_char), do: rest
  defp do_polymer_react(char, acc), do: [char | acc]

  defp react_removing_unit(char, chain) do
    chain
    |> Enum.filter(fn polymer -> polymer != char && polymer != (char + @char_diff) end)
    |> polymer_react()
    |> length()
  end
end
