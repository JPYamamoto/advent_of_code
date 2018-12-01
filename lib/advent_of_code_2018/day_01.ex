defmodule AdventOfCode2018.Day01 do
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
  Get the first number that is appears twice as the result
  of adding numbers one-by-one.

  Those numbers are retrieved from a `file`.

  If no result is found after adding all numbers, the loop
  goes back to the first number of the list.
  """
  @spec part1(String.t()) :: integer()
  def part2(file) do
    nums = file |> get_nums() |> Enum.to_list()
    [first | _] = nums

    repeated_sum(nums, 1, length(nums), first, [])
  end

  defp get_nums(file) do
    file_path = Path.join(:code.priv_dir(:advent_of_code_2018), file)

    file_path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing(&1))
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
