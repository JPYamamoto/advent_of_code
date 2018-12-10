defmodule AdventOfCode2018.Day08Test do
  use ExUnit.Case

  import AdventOfCode2018.Day08

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_08/test_1.txt" 
      result = part1(input)
  
      assert result == 138
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "day_08/test_1.txt"
      result = part2(input)
  
      assert result == 66
    end
  end
end
