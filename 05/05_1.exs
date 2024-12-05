[rules_input, updates_input] =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n\n", trim: true)

rules =
  rules_input
  |> String.split("\n", trim: true)
  |> Enum.flat_map(&String.split(&1, "\n", trim: true))
  |> Enum.map(fn line ->
    String.split(line, "|", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> List.to_tuple()
  end)
  |> IO.inspect()

updates =
  updates_input
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, ",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end)
  |> IO.inspect(charlists: :as_lists)

is_valid = fn update ->
  update
  |> Enum.with_index()
  |> Enum.all?(fn {current, index} ->
    Enum.slice(update, (index + 1)..-1//1)
    |> Enum.all?(fn next ->
      rules |> Enum.find(fn {l, r} -> l == next and r == current end) == nil
    end)
  end)
end

valid_updates =
  updates
  |> Enum.filter(is_valid)
  |> IO.inspect()

get_middle = fn list ->
  Enum.at(list, div(length(list), 2))
end

valid_updates
|> Enum.map(get_middle)
|> Enum.sum()
|> IO.write()
