defmodule AdventOfCode2018.Day14 do
  @first_recipes [3, 7]
  @offset 10
  @result_length 8

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 14](https://adventofcode.com/2018/day/14).
  """

  defmodule Scoreboard do
    def create, do: :ets.new(:recipes, [:set, :protected, :named_table])

    def insert(index, element), do: :ets.insert(:recipes, {index, element})

    def get(index) do
      #IO.inspect(index, label: "index")
      [{_, element}] = :ets.lookup(:recipes, index)
      element
    end
  end

  @doc """
  Starting from [3, 7], create recipes until reaching
  the number of recipes (`num_recipes`) that you are
  expected to complete. Once there, get the score of
  the following 10 recipes.
  """
  @spec part1(integer()) :: String.t()
  def part1(num_recipes) do
    Scoreboard.create

    @first_recipes
    |> Enum.with_index(1)
    |> Enum.each(fn {recipe, i} -> Scoreboard.insert(i, recipe) end)

    do_part1({1, 2}, 2, num_recipes)
  end

  @doc """
  Get the number of recipes that should be created
  before reaching the given scores (`recipes`).
  """
  @spec part2(String.t()) :: integer()
  def part2(recipes) do
    Scoreboard.create

    @first_recipes
    |> Enum.with_index(1)
    |> Enum.each(fn {recipe, i} -> Scoreboard.insert(i, recipe) end)

    do_part2({1, 2}, 2, Enum.join(@first_recipes), recipes)
  end

  defp do_part1(elfs, i_recipe, num_recipes) when i_recipe < num_recipes + @offset do
    recipes = get_recipes_of elfs
    last_index = recipes |> create_recipes |> add_to_scoreboard(i_recipe)
    new_elfs = move(elfs, recipes, last_index)

    do_part1(new_elfs, last_index, num_recipes)
  end
  defp do_part1(_, _, num_recipes) do
    (num_recipes + 1)..(num_recipes + @offset)
    |> Enum.map(fn i -> Scoreboard.get i end)
    |> Enum.join
  end

  defp do_part2(elfs, i_recipe, current_recipes, goal_recipes) do
    recipes = get_recipes_of elfs
    new_recipes = create_recipes recipes
    last_index = add_to_scoreboard(new_recipes, i_recipe)
    new_elfs = move(elfs, recipes, last_index)

    current_recipes = current_recipes <> Enum.join(new_recipes)

    if String.contains?(current_recipes, goal_recipes) do
      [leading | _] = String.split(current_recipes, goal_recipes)
      last_index - (String.length(current_recipes) - String.length(leading))
    else
      {_, current_recipes} = String.split_at(current_recipes, -@result_length)
      do_part2(new_elfs, last_index, current_recipes, goal_recipes)
    end
  end

  defp get_recipes_of({elf_1, elf_2}) do
    elf_1_recipe = Scoreboard.get elf_1
    elf_2_recipe = Scoreboard.get elf_2

    {elf_1_recipe, elf_2_recipe}
  end

  defp create_recipes({recipe_1, recipe_2}), do: Integer.digits(recipe_1 + recipe_2)

  defp add_to_scoreboard(recipes, i) do
    new_recipes = Enum.with_index(recipes, i + 1)

    Enum.each(new_recipes, fn {recipe, i} -> Scoreboard.insert(i, recipe) end)

    {_, index} = Enum.max_by(new_recipes, fn {_, i} -> i end)
    index
  end

  defp move({elf_1, elf_2}, {recipe_1, recipe_2}, last_index) do
    new_elf_1 = 1 + recipe_1 + elf_1
    new_elf_2 = 1 + recipe_2 + elf_2

    elf_1 = if new_elf_1 > last_index, do: rem(new_elf_1, last_index), else: new_elf_1
    elf_2 = if new_elf_2 > last_index, do: rem(new_elf_2, last_index), else: new_elf_2

    {elf_1, elf_2}
  end
end
