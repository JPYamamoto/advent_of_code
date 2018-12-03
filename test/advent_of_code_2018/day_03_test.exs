defmodule AdventOfCode2018.Day03Test do
  use ExUnit.Case

  import AdventOfCode2018.Day03

  describe "Test Part 1" do
    test "test_1" do
      input = "day_03/test_1.txt" 
      result = part1(input)
  
      assert result == 4
    end
  end

  describe "Test Part 2" do
    test "test_1" do
      input = "day_03/test_1.txt" 
      result = part2(input)
  
      assert result == "3"
    end
  end
end
