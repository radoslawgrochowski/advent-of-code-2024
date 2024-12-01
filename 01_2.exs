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

[left, right] =
  content
  |> Enum.zip()
  |> Enum.map(&Tuple.to_list/1)

IO.inspect(left)
IO.inspect(right)

similarity =
  left
  |> Enum.map(fn number ->
    occurences =
      right
      |> Enum.count(fn value -> number == value end)
    number * occurences
  end)
  |> Enum.sum

IO.inspect(similarity)
