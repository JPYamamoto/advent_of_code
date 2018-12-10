defmodule AdventOfCode2018.Utils.Zipper do
  def from_list([curr | prev]), do: {Enum.reverse(prev), [curr]}

  def curr({_, [curr | _]}), do: curr

  def back({[], [curr | []]}), do: {[], [curr]}
  def back({[last | []], post}), do: {Enum.reverse(post), [last]}
  def back({[last | prev], post}), do: {prev, [last | post]}

  def next({[], [curr | []]}), do: {[], [curr]}
  def next({prev, [curr | []]}), do: {[curr], Enum.reverse(prev)}
  def next({prev, [curr | next]}), do: {[curr | prev], next}

  def back_by(zlist, 0), do: zlist
  def back_by(zlist, num), do: back_by(back(zlist), num - 1)

  def next_by(zlist, 0), do: zlist
  def next_by(zlist, num), do: next_by(next(zlist), num - 1)

  def replace({prev, [_, next]}, new), do: {prev, [new | next]}

  def insert({prev, next}, new), do: {prev, [new | next]}

  def remove({prev, [_ | []]}), do: {[], Enum.reverse(prev)}
  def remove({prev, [_ | next]}), do: {prev, next}
end
