defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01

  describe "Tests Part 1" do
    test "test_1" do
      input = "day_01/part_1/test_1.txt" 
      result = part1(input)
  
      assert result == 3
    end

    test "test_2" do
      input = "day_01/part_1/test_2.txt" 
      result = part1(input)
  
      assert result == 0
    end

    test "test_3" do
      input = "day_01/part_1/test_3.txt" 
      result = part1(input)
  
      assert result == -6
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "day_01/part_2/test_1.txt" 
      result = part2(input)
  
      assert result == 0
    end

    test "test_2" do
      input = "day_01/part_2/test_2.txt" 
      result = part2(input)
  
      assert result == 10
    end

    test "test_3" do
      input = "day_01/part_2/test_3.txt" 
      result = part2(input)
  
      assert result == 5
    end

    test "test_4" do
      input = "day_01/part_2/test_4.txt" 
      result = part2(input)
  
      assert result == 14
    end
  end
end
