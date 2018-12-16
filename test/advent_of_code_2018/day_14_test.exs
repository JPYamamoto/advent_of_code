defmodule AdventOfCode2018.Day14Test do
  use ExUnit.Case

  import AdventOfCode2018.Day14

  describe "Tests Part 1" do
    test "test_1" do
      input = 9
      result = part1(input)
  
      assert result == "5158916779"
    end

    test "test_2" do
      input = 5
      result = part1(input)
  
      assert result == "0124515891"
    end
 
    test "test_3" do
      input = 18
      result = part1(input)
  
      assert result == "9251071085"
    end

    test "test_4" do
      input = 2018
      result = part1(input)
  
      assert result == "5941429882"
    end
  end

  describe "Tests Part 2" do
    test "test_1" do
      input = "51589" 
      result = part2(input)
  
      assert result == 9
    end

    test "test_2" do
      input = "01245" 
      result = part2(input)
  
      assert result == 5
    end

    test "test_3" do
      input = "92510" 
      result = part2(input)
  
      assert result == 18
    end

    test "test_4" do
      input = "59414" 
      result = part2(input)
  
      assert result == 2018
    end
  end
end
