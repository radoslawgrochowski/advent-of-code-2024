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
  if x >= 0 and y >= 0 and y < length(input) do
    IO.inspect({x, y})
    input |> Enum.at(y, "_") |> Enum.at(x, "_")

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
      if x >= 0 and y >= 0 and y < length(input) do
        IO.inspect({x, y})
        input |> Enum.at(y, "_") |> Enum.at(x, "_")
      else
        "_"
      end
    end

    valid_start = fn {x, y} ->
      bltr =
        char_at.({x - 1, y + 1}) <>
          char_at.({x, y}) <>
          char_at.({x + 1, y - 1})

      tlbr =
        char_at.({x - 1, y - 1}) <>
          char_at.({x, y}) <>
          char_at.({x + 1, y + 1})

      [bltr, tlbr, String.reverse(bltr), String.reverse(tlbr)]
      |> Enum.count(fn s -> s == "MAS" end) >= 2
    end

    times =
      cords
      |> Enum.map(fn cords ->
        valid_start.(cords)
      end)
      |> IO.inspect()
      |> Enum.map(fn
        false -> 0
        true -> 1
      end)
      |> Enum.sum()

    IO.write(times)
  else
    "_"
  end
end

valid_start = fn {x, y} ->
  bltr =
    char_at.({x - 1, y + 1}) <>
      char_at.({x, y}) <>
      char_at.({x + 1, y - 1})

  tlbr =
    char_at.({x - 1, y - 1}) <>
      char_at.({x, y}) <>
      char_at.({x + 1, y + 1})

  [bltr, tlbr, String.reverse(bltr), String.reverse(tlbr)]
  |> Enum.count(fn s -> s == "MAS" end) >= 2
end

times =
  cords
  |> Enum.map(fn cords ->
    valid_start.(cords)
  end)
  |> IO.inspect()
  |> Enum.map(fn
    false -> 0
    true -> 1
  end)
  |> Enum.sum()

IO.write(times)
