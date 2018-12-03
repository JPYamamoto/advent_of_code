defmodule AdventOfCode2018.Utils do
  def stream_lines(file) do
    file_path = Path.join(:code.priv_dir(:advent_of_code_2018), file)

    file_path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing(&1))
  end
end
