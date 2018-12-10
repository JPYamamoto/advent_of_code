defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  import AdventOfCode2018.Day09

  @shortdoc "Day 09 Part 1"
  def run(_) do
    num_players = 463
    last_marble = 71787

    solution(num_players, last_marble)
    |> IO.inspect(label: "Part 1 Results") 
  end
end   
