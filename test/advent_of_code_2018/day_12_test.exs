defmodule AdventOfCode2018.Day12Test do
  use ExUnit.Case

  import AdventOfCode2018.Day12

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_12/test_1.txt" 
      result = part1(input)
  
      assert result == 325
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "day_12/test_1.txt" 
      result = part2(input)
  
      assert result == 999999999374
    end
  end
end
