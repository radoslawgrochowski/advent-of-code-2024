content =
  System.argv()
  |> hd
  |> File.read!()

IO.inspect(content, label: "content")

distance =
  String.split(content, "\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, " ", trim: true)
    |> Enum.map(fn string -> String.to_integer(string) end)
  end)
  |> Enum.zip()
  |> Enum.map(fn tuple -> Tuple.to_list(tuple) |> Enum.sort() |> Enum.to_list() end)
  |> Enum.zip()
  |> Enum.map(fn pair ->
    {left, right} = pair
    abs(left-right)
  end)
  |> Enum.sum()

IO.write(distance)
