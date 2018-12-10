defmodule AdventOfCode2018.Day09 do
  alias AdventOfCode2018.Utils.Zipper

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 09](https://adventofcode.com/2018/day/9).
  """

  @doc """
  Get the score of the winner, given a number of `players` and
  the number of `marbles` in the Elves' Marbles Game.

  The game is played by taking turns to locate a marble two
  positions to the left from the last marble. Every 23 turns,
  the player in turn will not place a marble in the circle and
  will also remove the marble located 7 positions before the
  current one. The index of both marbles taken, will be added
  to the score of the player. 

  The player with the highest score after having placed all
  `marbles` is the winner.
  """
  @spec solution(integer(), integer()) :: integer()
  def solution(players, marbles) do
    {_, score} = Zipper.from_list([0])
      |> add_marble(Map.new(1..players, fn player -> {player, 0} end), {1, players}, {1, marbles})
      |> Enum.max_by(fn {_, score} -> score end)

    score
  end

  defp add_marble(zlist, scores, {player_i, last_p}, m_data) when player_i > last_p do
    add_marble(zlist, scores, {1, last_p}, m_data)
  end
  defp add_marble(_, scores, _, {marble_i, last_m}) when marble_i > last_m, do: scores
  defp add_marble(zlist, scores, {player_i, last_p}, {marble_i, last_m}) when rem(marble_i, 23) == 0 do
    scores = Map.update(scores, player_i, 0, &(&1 + marble_i))
    zlist = Zipper.back_by(zlist, 7)
    scores = Map.update(scores, player_i, 0, &(&1 + Zipper.curr(zlist)))
    add_marble(Zipper.remove(zlist), scores, {player_i + 1, last_p}, {marble_i + 1, last_m})
  end
  defp add_marble(zlist, scores, {player_i, last_p}, {marble_i, last_m}) do
    zlist = zlist |> Zipper.next_by(2) |> Zipper.insert(marble_i)
    add_marble(zlist, scores, {player_i + 1, last_p}, {marble_i + 1, last_m})
  end
end
