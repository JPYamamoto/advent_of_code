defmodule AdventOfCode2018.Day02Test do
  use ExUnit.Case

  import AdventOfCode2018.Day02

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_02/part_1/test_1.txt" 
      result = part1(input)
  
      assert result == 12
    end
  end

  describe "Tests Part 2" do
    test "part2" do
      input = "day_02/part_2/test_1.txt"
      result = part2(input)
  
      assert result == "fgij"
    end
  end
end
