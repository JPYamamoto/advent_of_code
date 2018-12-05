defmodule AdventOfCode2018.Day04Test do
  use ExUnit.Case

  import AdventOfCode2018.Day04

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_04/test_1.txt" 
      result = part1(input)
  
      assert result == 240
    end
  end

  describe "Test Part 2" do
    test "part2" do
      input = "day_04/test_1.txt"
      result = part2(input)
  
      assert result == 4455
    end
  end
end
