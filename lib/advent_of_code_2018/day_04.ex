defmodule AdventOfCode2018.Day04 do
  alias AdventOfCode2018.Utils

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 04](https://adventofcode.com/2018/day/4).
  """

  @doc """
  Parse the records in chronological order from a `file`
  and get the ID of the guard that spends the most time
  asleep, and multiply it by the minute in which the
  guard most often is asleep.
  """
  @spec part1(String.t()) :: integer()
  def part1(file) do
    guards_schedule = file |> Utils.stream_lines() |> get_intervals()

    {id, intervals} = guards_schedule
      |> Enum.sort_by(fn {_, intervals} -> get_time_asleep_of(intervals) end, &>/2)
      |> Enum.at(0)

    [[minute | _] | _] = intervals
    |> get_minutes_of()
    |> Enum.sort(fn minute1, minute2 -> length(minute1) > length(minute2) end)

    id * minute
  end

  @doc """
  Parse the records in chronological order from a `file`
  and get the ID of the guard that is asleep the most
  often at any given minute, and get the product of the
  ID and the minute.
  """
  @spec part2(String.t()) :: integer()
  def part2(file) do
    {id, {minute, _}} = file
    |> Utils.stream_lines()
    |> get_intervals()
    |> Enum.map(fn {id, intervals} -> {id, intervals |> get_minutes_of() |> max_minutes()} end)
    |> Enum.filter(fn {_, minute} -> minute end)
    |> Enum.sort_by(fn {_, {_, counter}} -> counter end, &>/2)
    |> Enum.at(0)

    id * minute
  end

  defp get_intervals(records) do
    {_, _, schedules} = records
    |> Enum.sort()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce({nil, nil, %{}}, &parse_guard/2)

    schedules
  end

  defp parse_line(<<_ :: binary-size(15), mins :: binary-size(2), _ :: binary-size(2), action :: bitstring>>) do
    case action do
      "Guard #" <> rest -> {:guard, rest |> String.split() |> Enum.at(0) |> String.to_integer()}
      "falls asleep" -> {:sleep, String.to_integer(mins)}
      "wakes up" -> {:wake_up, String.to_integer(mins)}
    end
  end

  defp parse_guard({:guard, id}, {_, nil, acc}), do: {id, nil, Map.put_new(acc, id, [])}
  defp parse_guard({:sleep, minute}, {l_id, nil, acc}), do: {l_id, minute, acc}
  defp parse_guard({:wake_up, min}, {l_id, l_min, acc}) do
    {l_id, nil, Map.update!(acc, l_id, &([{l_min, min} | &1]))}
  end

  defp get_time_asleep_of(guard) do
    guard |> Enum.map(fn {sleep_min, wake_min} -> wake_min - sleep_min end) |> Enum.sum()
  end

  defp get_minutes_of(guard_intervals) do
    guard_intervals
    |> Enum.flat_map(fn {sleep_min, wake_min} -> for min <- sleep_min..(wake_min - 1), do: min end)
    |> Enum.sort()
    |> Enum.chunk_by(&(&1))
  end

  defp max_minutes(min_intervals) do
    min_intervals
    |> Enum.map(fn min -> {Enum.at(min, 0), length(min)} end)
    |> Enum.sort_by(fn {_, count} -> count end, &>/2)
    |> Enum.at(0)
  end
end
