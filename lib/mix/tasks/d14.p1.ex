defmodule Mix.Tasks.D14.P1 do
  use Mix.Task

  import AdventOfCode2018.Day14

  @shortdoc "Day 14 Part 1"
  def run(_) do
    input = 681901

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results") 
  end
end   
