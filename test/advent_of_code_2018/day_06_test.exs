defmodule AdventOfCode2018.Day06Test do
  use ExUnit.Case

  import AdventOfCode2018.Day06

  describe "Tests Part 1" do
    test "part1" do
      input = "day_06/test_1.txt" 
      result = part1(input)
  
      assert result == 17
    end
  end

  describe "Tests Part 2" do
    test "part2" do
      input = "day_06/test_1.txt"
      result = part2(input, 32)
  
      assert result == 16
    end
  end
end
