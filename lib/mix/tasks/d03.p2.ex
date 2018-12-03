defmodule Mix.Tasks.D03.P2 do
  use Mix.Task

  import AdventOfCode2018.Day03

  @shortdoc "Day 03 Part 2"
  def run(_) do
    input = "day_03/input.txt"

    input
    |> part2() 
    |> IO.inspect(label: "Part 2 Results") 
  end
end   
