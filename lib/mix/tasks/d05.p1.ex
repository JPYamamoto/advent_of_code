defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  import AdventOfCode2018.Day05

  @shortdoc "Day 05 Part 1"
  def run(_) do
    input = "day_05/input.txt"

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results") 
  end
end   
