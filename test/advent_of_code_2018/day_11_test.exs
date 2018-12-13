defmodule AdventOfCode2018.Day11Test do
  use ExUnit.Case

  import AdventOfCode2018.Day11

  describe "Tests Part 1" do
    test "test_1" do
      input = 18 
      result = part1(input)
  
      assert result == "33,45"
    end
    test "test_2" do
      input = 42 
      result = part1(input)
  
      assert result == "21,61"
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = 18 
      result = part2(input)
  
      assert result == "90,269,16"
    end
    test "test_2" do
      input = 42 
      result = part2(input)
  
      assert result == "232,251,12"
    end
  end
end
