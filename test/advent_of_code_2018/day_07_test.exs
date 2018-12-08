defmodule AdventOfCode2018.Day07Test do
  use ExUnit.Case

  import AdventOfCode2018.Day07

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_07/test_1.txt" 
      result = part1(input)
  
      assert result == "CABDFE"
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "day_07/test_1.txt"
      result = part2(input, 2, 0)
  
      assert result == 15
    end
  end
end
