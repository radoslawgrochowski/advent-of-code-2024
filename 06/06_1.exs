input =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))
  |> IO.inspect(label: "input")

cords =
  input
  |> Enum.with_index()
  |> Enum.map(fn {line, y} ->
    line
    |> Enum.with_index()
    |> Enum.map(fn {_, x} -> {x, y} end)
  end)
  |> List.flatten()

xl = length(input |> Enum.at(0))
yl = length(input)

at = fn {x, y} ->
  if x >= 0 and y >= 0 and y < yl and x < xl do
    input |> Enum.at(y, ~c"_") |> Enum.at(x, ~c"_")
  else
    :out
  end
end

directions = [
  {0, -1},
  {1, 0},
  {0, 1},
  {-1, 0}
]

next_direction = fn dir ->
  index =
    directions
    |> Enum.find_index(fn d -> dir == d end)

  Enum.at(directions, rem(index + 1, length(directions)))
end

obstacle? = fn pos ->
  at.(pos) == "#"
end

step =
  fn {pos, dir} ->
    {dx, dy} = dir
    {x, y} = pos
    next = {x + dx, y + dy}

    cond do
      at.(next) == :out ->
        :out

      obstacle?.(next) ->
        {pos, next_direction.(dir)}

      true ->
        {next, dir}
    end
    |> IO.inspect(label: "next step")
  end

start_pos = cords |> Enum.find(fn pos -> at.(pos) == "^" end) |> IO.inspect()
start_dir = directions |> hd() |> IO.inspect()

Stream.unfold(
  {start_pos, start_dir},
  fn
    :out -> nil
    x -> {x, step.(x)}
  end
)
|> Enum.to_list()
|> Enum.map(fn {pos, dir} -> pos end)
|> Enum.uniq()
|> Enum.count()
|> IO.write()
