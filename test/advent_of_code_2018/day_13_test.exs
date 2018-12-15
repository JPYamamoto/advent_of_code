defmodule AdventOfCode2018.Day13Test do
  use ExUnit.Case

  import AdventOfCode2018.Day13

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_13/part_1/test_1.txt" 
      result = part1(input)
  
      assert result == "7,3"
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "day_13/part_2/test_1.txt" 
      result = part2(input)
  
      assert result == "6,4"
    end
  end
end
