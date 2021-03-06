defmodule AdventOfCode2018.Day01 do
  alias AdventOfCode2018.Utils

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 01](https://adventofcode.com/2018/day/1).
  """

  @doc """
  Get the sum of all numbers contained in a `file`.

  It should be given in a string as the path, relative to the `priv` directory.

  Returns the integer of all numbers added together.
  """
  @spec part1(String.t()) :: integer()
  def part1(file) do
    file
    |> get_nums()
    |> Enum.sum()
  end

  @doc """
  Get the first number that appears twice as the result
  of adding numbers one-by-one.

  Those numbers are retrieved from a `file`.

  If no result is found after adding all numbers, the loop
  goes back to the first number of the list.
  """
  @spec part2(String.t()) :: integer()
  def part2(file) do
    nums = file |> get_nums() |> Enum.to_list()
    [first | _] = nums

    repeated_sum(nums, 1, length(nums), first, [])
  end

  defp get_nums(file) do
    file
    |> Utils.stream_lines()
    |> Stream.map(&String.to_integer(&1))
  end

  defp repeated_sum(list, position, length, acc, results) when position >= length do
    repeated_sum(list, 0, length, acc, results)
  end
  defp repeated_sum(list, position, length, acc, results) do
    sum = acc + Enum.at(list, position)
    if sum in results do
      sum
    else
      repeated_sum(list, position + 1, length, sum, [sum | results])
    end
  end
end
