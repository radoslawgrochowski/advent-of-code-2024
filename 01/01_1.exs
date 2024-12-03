content =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, " ", trim: true)
    |> Enum.map(fn string -> String.to_integer(string) end)
  end)

IO.inspect(content, label: "content")

distance =
  content
  |> Enum.zip()
  |> Enum.map(fn tuple -> Tuple.to_list(tuple) |> Enum.sort() |> Enum.to_list() end)
  |> Enum.zip()
  |> Enum.map(fn {left, right} -> abs(left - right) end)
  |> Enum.sum()

IO.write(distance)
