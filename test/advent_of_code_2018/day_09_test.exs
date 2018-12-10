defmodule AdventOfCode2018.Day09Test do
  use ExUnit.Case

  import AdventOfCode2018.Day09

  describe "Tests Parts 1 and 2" do
    test "test_1" do
      num_players = 9
      last_marble = 25
      result = solution(num_players, last_marble)
  
      assert result == 32
    end
    test "test_2" do
      num_players = 10
      last_marble = 1618
      result = solution(num_players, last_marble)
  
      assert result == 8317
    end
    test "test_3" do
      num_players = 13
      last_marble = 7999
      result = solution(num_players, last_marble)
  
      assert result == 146373
    end
    test "test_4" do
      num_players = 17
      last_marble = 1104
      result = solution(num_players, last_marble)
  
      assert result == 2764
    end
    test "test_5" do
      num_players = 21
      last_marble = 6111
      result = solution(num_players, last_marble)
  
      assert result == 54718
    end
    test "test_6" do
      num_players = 30
      last_marble = 5807
      result = solution(num_players, last_marble)
  
      assert result == 37305
    end
  end
end
