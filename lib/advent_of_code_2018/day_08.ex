defmodule AdventOfCode2018.Day08 do
  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 08](https://adventofcode.com/2018/day/8).
  """

  @doc """
  Parse a `file` containing a set of numbers, as a tree,
  and get the sum of all values considered as metadata.

  The `file` has the following format:
  [number of children] [number of metadata elements] [children (recursive)] [metadata elements]
  In children, you will find more nodes containing the same format.
  """
  @spec part1(String.t()) :: integer()
  def part1(file), do: file |> parse_content() |> sum_metadata()

  @doc """
  Parse a `file` containing a set of numbers, as a tree,
  and get the sum of the values of the children with their
  index listed in the metadata elements. If the node has
  no children, return the sum of its metadata elements as
  the value of the node.

  The `file` has the following format:
  [number of children] [number of metadata elements] [children (recursive)] [metadata elements]
  In children, you will find more nodes containing the same format.
  """
  @spec part2(String.t()) :: integer()
  def part2(file), do: file |> parse_content() |> Enum.map(&node_value/1) |> Enum.sum()

  defp parse_content(file) do
    file_path = Path.join(:code.priv_dir(:advent_of_code_2018), file)

    {result, _} = file_path
      |> File.read!()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> parse_node()

    result
  end

  defp parse_node([0, num_meta | rest]) do
    {meta, rest} = Enum.split(rest, num_meta) 
    {[{{0, num_meta, meta}, []}], rest}
  end
  defp parse_node([num_children, num_meta| rest]) do
    {result, rest} = parse_nodes(rest, [], num_children)
    {meta, rest} = Enum.split(rest, num_meta) 
    {[{{num_children, num_meta, meta}, result}], rest}
  end

  defp parse_nodes(elements, acc, 0), do: {acc, elements}
  defp parse_nodes(elements, acc, iter) do
    {results, rest} = parse_node(elements)
    parse_nodes(rest, Enum.concat(acc, results), iter - 1)
  end

  defp sum_metadata(data), do: data |> get_meta() |> List.flatten() |> Enum.sum()

  defp get_meta([]), do: [0]
  defp get_meta(data), do: Enum.map(data, fn {{_, _, metas}, children} -> [Enum.sum(metas) | get_meta(children)] end)

  defp node_value(nil), do: 0
  defp node_value({{0, _, metas}, _}), do: Enum.sum(metas)
  defp node_value({{_, _, metas}, children}) do
    metas
    |> Enum.reject(fn index -> index == 0 end)
    |> Enum.map(fn index -> Enum.at(children, index - 1, nil) |> node_value() end)
    |> Enum.sum()
  end
end
