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

char_at = fn {x, y} ->
  if x >= 0 and y >= 0 do
    input |> Enum.at(y, ~c"_") |> Enum.at(x, ~c"_")
  else
    "_"
  end
end

xmas? = fn {x, m, a, s} ->
  char_at.(x) == "X" and
    char_at.(m) == "M" and
    char_at.(a) == "A" and
    char_at.(s) == "S"
end

valid_start = fn {x, y} ->
  [
    xmas?.({{x, y}, {x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3}}),
    xmas?.({{x, y}, {x, y - 1}, {x, y - 2}, {x, y - 3}}),
    xmas?.({{x, y}, {x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}}),
    xmas?.({{x, y}, {x - 1, y}, {x - 2, y}, {x - 3, y}}),
    xmas?.({{x, y}, {x + 1, y}, {x + 2, y}, {x + 3, y}}),
    xmas?.({{x, y}, {x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}}),
    xmas?.({{x, y}, {x, y + 1}, {x, y + 2}, {x, y + 3}}),
    xmas?.({{x, y}, {x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}})
  ]
  |> Enum.count(fn x -> !!x end)
end

times =
  cords
  |> Enum.map(fn cords ->
    valid_start.(cords)
  end)
  |> Enum.sum()

IO.write(times)
