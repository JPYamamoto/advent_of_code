defmodule AdventOfCode2018.Day10Test do
  use ExUnit.Case

  import AdventOfCode2018.Day10

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_10/test_1.txt" 
      result = part1(input)
  
      assert result == """
        #...#..###
        #...#...#.
        #...#...#.
        #####...#.
        #...#...#.
        #...#...#.
        #...#...#.
        #...#..###
        """
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "day_10/test_1.txt" 
      result = part2(input)
  
      assert result == 3
    end
  end
end
