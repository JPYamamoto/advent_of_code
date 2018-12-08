defmodule AdventOfCode2018.Day07 do
  alias AdventOfCode2018.Utils

  @char_diff ?A - 1

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 07](https://adventofcode.com/2018/day/7).
  """

  @doc """
  Get the order in which a set of tasks should be
  performed, considering the dependencies that
  they have on other tasks.
  """
  @spec part1(String.t()) :: String.t()
  def part1(file) do
    instructions = steps_to_tuples(file)

    instructions
    |> get_keys()
    |> order([], [], instructions)
    |> Enum.join()
  end

  @doc """
  Get the number of seconds that will take to complete all
  tasks in order, considering their respective dependencies.

  A number `limit` of workers can work on different tasks
  at the same time, as long as their dependencies allow it.

  A number of seconds `delay` will be added to each task
  before being completed.
  """
  @spec part2(String.t(), integer(), integer()) :: integer()
  def part2(file, limit, delay) do
    steps = steps_to_tuples(file)
    keys_map = steps
      |> get_keys() 
      |> Enum.reduce(%{}, fn key, acc -> Map.update(acc, key, [], fn _ -> [] end) end)

    steps_deps = Enum.reduce(steps, keys_map, fn {prev, post}, acc ->
        Map.update(acc, post, nil, &([prev | &1]))
      end)

    {workers, waitlist} = no_deps = steps_deps |> ready_to_work(delay) |> take(limit)

    count_seconds(workers, waitlist, remove_ready_to_work(steps_deps, no_deps), limit, delay, 0)
  end

  defp get_keys(steps) do
    steps
    |> Enum.reduce([], fn {x, y}, acc -> [x, y | acc] end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp ready_to_work(steps, delay) do
    steps
    |> Enum.filter(fn {_, deps} -> deps == [] end)
    |> Enum.map(fn {<<code :: utf8>> = key, _} -> {key, {1, code - @char_diff + delay}} end)
  end

  defp take(list, number), do: Enum.split(list, number)

  defp remove_ready_to_work(steps_deps, {set1, set2}) do
    get_keys = fn {key, _}, acc -> [key | acc] end
    keys = Enum.concat(
        Enum.reduce(set1, [], &(get_keys.(&1, &2))),
        Enum.reduce(set2, [], &(get_keys.(&1, &2)))
      )
    Enum.reject(steps_deps, fn {key, _} -> key in keys end)
  end

  defp count_seconds([], [], [], _, _, iteration), do: iteration
  defp count_seconds(workers, waitlist, steps_deps, limit, delay, iteration) do
    {finished, workers} = remove_finished(workers)
    workers = add_second(workers)
    steps_deps = remove_deps(steps_deps, finished)
    no_deps = ready_to_work(steps_deps, delay)
    {new_workers, waitlist} = take(waitlist ++ no_deps, limit - length(workers))

    count_seconds(workers ++ new_workers, waitlist, remove_ready_to_work(steps_deps, {new_workers, waitlist}), limit, delay, iteration + 1)
  end

  defp remove_finished(workers) do
    finished? = fn {_, {seconds, limit}} -> seconds == limit end
    finished = workers |> Enum.filter(&(finished?.(&1))) |> Enum.map(fn {key, _} -> key end)
    in_progress = Enum.reject(workers, &(finished?.(&1)))
    {finished, in_progress}
  end

  defp remove_deps(steps_deps, completed_steps) do
    Enum.map(steps_deps, fn {key, deps} ->
        {key, Enum.reject(deps, fn dep -> dep in completed_steps end)}
      end)
  end

  defp add_second(workers) do
    Enum.map(workers, fn {key, {second, limit}} -> {key, {second + 1, limit}} end)
  end

  defp steps_to_tuples(file), do: file |> Utils.stream_lines() |> Enum.map(&parse_steps/1)

  defp parse_steps(<<_ :: binary-size(5), prev :: binary-size(1), _ :: binary-size(30),
                   post :: binary-size(1), _ :: bitstring>>), do: {prev, post}

  defp order([], [], result, _), do: Enum.reverse(result)
  defp order([step | rest], acc, result, instructions) do
    case following?(step, instructions) do
      true -> order(Enum.reverse(acc) ++ rest, [], [step | result], remove(instructions, step))
      false -> order(rest, [step | acc], result, instructions)
    end
  end

  defp following?(_, []), do: true
  defp following?(item, [{_, item} | _]), do: false
  defp following?(item, [{_, _} | rest]), do: following?(item, rest)

  defp remove(instructions, item), do: Enum.reject(instructions, fn {step, _} -> step == item end)
end
