defmodule AdventOfCode2018.Day13 do
  @carts ~w|< > ^ v|
  @rails ~w|/ \\ +|

  @moduledoc """
  Module for [AdventOfCode](https://adventofcode.com/) - [Day 13](https://adventofcode.com/2018/day/13).
  """

  defmodule Cart do
    defstruct [:id, :location, :direction, :next_turn, :crashed?]
  end

  @doc """
  Parse the data of the given `file`, corresponding to a
  map of a mine with railways and carts. Get the position
  at which the first cart collision occurs.
  """
  @spec part1(String.t()) :: String.t()
  def part1(file) do
    mine = parse_content(file)
    carts = parse_carts(mine)
    rails = parse_rails(mine)

    carts |> tick_until_crash(rails) |> print_coords
  end

  @doc """
  Parse the data of the given `file` corresponding to a
  map of a mine with railways and carts. Get the position
  of the remaining cart just after the last collision
  occurs.
  """
  @spec part2(String.t()) :: String.t()
  def part2(file) do
    mine = parse_content(file)
    carts = parse_carts(mine)
    rails = parse_rails(mine)

    carts |> tick_until_one_left(rails) |> print_coords
  end

  defp parse_content(file) do
    file_path = Path.join(:code.priv_dir(:advent_of_code_2018), file)

    file_path
    |> File.stream!()
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {lines, y}, acc ->
      lines
      |> String.graphemes
      |> Enum.with_index
      |> Enum.filter(&(!match?({" ", _}, &1)))
      |> Enum.reduce(acc, fn {point, x}, acc ->
        Map.put(acc, {x, y}, point)
      end)
    end)
  end

  defp parse_carts(mine) do
    mine
    |> Enum.filter(fn {_, item} -> item in @carts end)
    |> Enum.with_index
    |> Enum.map(fn {{coords, cart}, index} ->
      direction =
        case cart do
          "<" -> :left
          ">" -> :right
          "^" -> :up
          "v" -> :down
        end

      {index, %Cart{id: index, location: coords, direction: direction, next_turn: :left, crashed?: false}}
    end)
    |> Map.new
  end

  defp parse_rails(mine) do
    mine
    |> Enum.map(fn {coords, rail} ->
      new_rail =
        case rail do
          "<" -> "-"
          ">" -> "-"
          "^" -> "|"
          "v" -> "|"
          good_rail -> good_rail
        end
      
      {coords, new_rail}
    end)
    |> Map.new
  end

  defp tick_until_crash(carts, rails) do
    state = tick(carts, rails)
    crashed_car = Enum.find(state, fn {_, %Cart{crashed?: crashed?}} -> crashed? end)

    case crashed_car do
      nil -> tick_until_crash(state, rails)
      _ -> crashed_car
    end
  end

  defp tick_until_one_left(carts, rails) do
    state =
      carts
      |> tick(rails)
      |> Enum.filter(fn {_, %Cart{crashed?: crashed?}} -> !crashed? end)

    case length(state) == 1 do
      true -> hd(state)
      _ -> tick_until_one_left(Map.new(state), rails)
    end
  end

  defp tick(carts, rails) do
    carts
    |> sort_by_location
    |> Enum.map(fn {index, _} -> index end)
    |> Enum.reduce(carts, &next_location/2)
    |> Enum.map(fn {i, cart} -> {i, turn(cart, rails)} end)
    |> Map.new
  end

  defp sort_by_location(carts),
    do: Enum.sort_by(carts, fn {_, %Cart{location: {x, y}}} -> {y, x} end)

  defp next_location(cart_id, carts) do
    %{^cart_id => cart} = carts
    %Cart{location: {x, y}, crashed?: crashed?} = cart

    new_location =
      case cart.direction do
        :left -> {x - 1, y}
        :right -> {x + 1, y}
        :up -> {x, y - 1}
        :down -> {x, y + 1}
      end

    cart =
      case crashed? do
        false -> %Cart{cart | location: new_location}
        true -> cart
      end

    crash(cart, carts)
  end

  defp crash(%Cart{location: location, id: id} = cart, carts) do
    cart_crashed? = Enum.any?(carts, fn {_, %Cart{location: coords}} -> coords == location end)
    new_carts = Map.new(
      case cart_crashed? do
        true -> Enum.map(carts, fn {i, %Cart{location: coords} = cart} ->
          if coords == location, do: {i, %Cart{cart | crashed?: true}}, else: {i, cart}
        end)
        false -> carts
      end
    )

    case cart_crashed? do
      true -> Map.replace!(new_carts, id, %Cart{cart | crashed?: true})
      false -> Map.replace!(new_carts, id, cart)
    end
  end

  defp turn(%Cart{location: location} = cart, rails) do
    rail = Map.fetch!(rails, location)
    case rail in @rails do
      true -> rotate(rail, cart)
      _ -> cart
    end
  end

  defp rotate("/", %Cart{direction: :left} = cart), do: %Cart{cart | direction: :down}
  defp rotate("/", %Cart{direction: :right} = cart), do: %Cart{cart | direction: :up}
  defp rotate("/", %Cart{direction: :up} = cart), do: %Cart{cart | direction: :right}
  defp rotate("/", %Cart{direction: :down} = cart), do: %Cart{cart | direction: :left}
  defp rotate("\\", %Cart{direction: :left} = cart), do: %Cart{cart | direction: :up}
  defp rotate("\\", %Cart{direction: :right} = cart), do: %Cart{cart | direction: :down}
  defp rotate("\\", %Cart{direction: :up} = cart), do: %Cart{cart | direction: :left}
  defp rotate("\\", %Cart{direction: :down} = cart), do: %Cart{cart | direction: :right}
  defp rotate("+", %Cart{direction: direction, next_turn: next_turn} = cart) do
    {new_direction, new_next_turn} =
      case {direction, next_turn} do
        {_, :straight} -> {direction, :right}
        {:left, :left} -> {:down, :straight}
        {:left, :right} -> {:up, :left}
        {:right, :left} -> {:up, :straight}
        {:right, :right} -> {:down, :left}
        {:down, :left} -> {:right, :straight}
        {:down, :right} -> {:left, :left}
        {:up, :left} -> {:left, :straight}
        {:up, :right} -> {:right, :left}
      end

    %Cart{cart | direction: new_direction, next_turn: new_next_turn}
  end

  defp print_coords({_, %Cart{location: {x, y}}}), do: "#{x},#{y}"
end
