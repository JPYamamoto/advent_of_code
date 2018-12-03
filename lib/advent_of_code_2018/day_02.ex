defmodule AdventOfCode2018.Day02 do
  alias AdventOfCode2018.Utils

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 02](https://adventofcode.com/2018/day/2).
  """

  defmodule Counter do
    use Agent

    @moduledoc """
    Agent that stores how many IDs have two and three repeated letters.
    """

    @doc """
    Function to start the `Counter` with initial values set to `0`.
    """
    @spec start_link() :: Agent.on_start()
    def start_link do
      Agent.start_link(fn -> %{two: 0, three: 0} end, name: __MODULE__)
    end

    @doc """
    Increment the value `two` by one.

    This function is used when an ID has a twice-repeted letter.
    """
    @spec contains_two() :: :ok
    def contains_two do
      Agent.update(__MODULE__, fn map -> Map.update!(map, :two, &(&1 + 1)) end)
    end

    @doc """
    Increment the value `three` by one.

    This function is used when an ID has a letter that appears three times.
    """
    @spec contains_three() :: :ok
    def contains_three do
      Agent.update(__MODULE__, fn map -> Map.update!(map, :three, &(&1 + 1)) end)
    end

    @doc """
    Get the values stored in the `Counter`.
    """
    @spec values() :: map()
    def values do
      Agent.get(__MODULE__, fn values -> values end)
    end

    @doc """
    Stop the `Agent`.
    """
    @spec stop() :: :ok
    def stop do
      Agent.stop(__MODULE__)
    end
  end

  defp get_repetitions(word) do
    chars = String.graphemes word

    count = chars
      |> Enum.uniq()
      |> Enum.map(fn char -> Enum.count(chars, &(&1 == char)) end)
    
    if 2 in count, do: Counter.contains_two()
    if 3 in count, do: Counter.contains_three()
  end

  defp compare(original_str, lines) do
    lines
    |> Stream.map(fn line -> {line, original_str, String.jaro_distance(original_str, line)} end)
    |> Stream.filter(fn {_, _, value} -> value != 0 && value != 1 end)
    |> Enum.to_list()
  end

  @doc """
  Get a checksum from the product of the number of
  IDs that contain a letter that appears twice, times the
  numbers of IDs with a letter that appears three times.

  Retrieve the IDs from a `file`.
  """
  @spec part1(String.t()) :: integer()
  def part1(file) do
    Counter.start_link()

    file
    |> Utils.stream_lines()
    |> Stream.each(&get_repetitions/1)
    |> Stream.run()

    %{two: val_two, three: val_three} = Counter.values()

    Counter.stop()

    val_two * val_three
  end

  @doc """
  Get the chars shared by two IDs that are
  different by only one letter holding
  the same position in both words.

  Retrieve the IDs from a `file`.
  """
  @spec part1(String.t()) :: String.t()
  def part2(file) do
    lines = Utils.stream_lines(file)

    {id_1, id_2, _} = lines
      |> Stream.flat_map(fn line -> compare(line, lines) end)
      |> Enum.max_by(fn {_, _, value} -> value end)

    id_1
    |> String.myers_difference(id_2)
    |> Keyword.get_values(:eq)
    |> Enum.join()
  end
end
