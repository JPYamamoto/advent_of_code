defmodule AdventOfCode2018.Day05Test do
  use ExUnit.Case

  import AdventOfCode2018.Day05

  describe "Tests Part 1" do
    test "part1" do
      input = "day_05/test_1.txt" 
      result = part1(input)
  
      assert result == 10
    end
  end

  describe "Tests Part 2" do
    test "part2" do
      input = "day_05/test_1.txt" 
      result = part2(input)
  
      assert result == 4
    end
  end
end
