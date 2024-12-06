input =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))

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

at = fn input, {x, y} ->
  if x >= 0 and y >= 0 and y < yl and x < xl do
    input |> Enum.at(y, ~c"_") |> Enum.at(x, ~c"_")
  else
    :out
  end
end

set_obstacle = fn input, {x, y} ->
  input
  |> List.replace_at(
    y,
    List.replace_at(Enum.at(input, y), x, "#")
  )
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

obstacle? = fn input, pos ->
  at.(input, pos) == "#"
end

step =
  fn input, {pos, dir} ->
    {dx, dy} = dir
    {x, y} = pos
    next = {x + dx, y + dy}

    cond do
      at.(input, next) == :out ->
        :out

      obstacle?.(input, next) ->
        {pos, next_direction.(dir)}

      true ->
        {next, dir}
    end
  end

start_pos = cords |> Enum.find(fn pos -> at.(input, pos) == "^" end)
start_dir = directions |> hd()
start = {start_pos, start_dir}

walk = fn input, start ->
  Stream.unfold(
    [start],
    fn
      [:out | _] ->
        nil

      [:cycle | _] ->
        nil

      history ->
        current = hd(history)
        next = step.(input, current)

        if Enum.member?(history, next) do
          {:cycle, [:cycle | history]}
        else
          {current, [next | history]}
        end
    end
  )
end

uniq_pos =
  walk.(input, start)
  |> Enum.to_list()
  |> Enum.map(fn {pos, _} -> pos end)
  |> Enum.uniq()

uniq_pos_count = uniq_pos |> Enum.count()

uniq_pos
|> Enum.with_index()
|> Enum.count(fn {pos, index} ->
  new_input = set_obstacle.(input, pos)
  IO.inspect({index, uniq_pos_count})

  walk.(new_input, start)
  |> Enum.to_list()
  |> Enum.at(-1) == :cycle
end)
|> IO.write()
