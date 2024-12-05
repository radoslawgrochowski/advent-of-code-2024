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

is_invalid = fn update ->
  update
  |> Enum.with_index()
  |> Enum.any?(fn {current, index} ->
    Enum.slice(update, (index + 1)..-1//1)
    |> Enum.any?(fn next ->
      rules |> Enum.any?(fn {l, r} -> l == next and r == current end)
    end)
  end)
end

rules_both_ways = rules ++ Enum.reverse(rules)

invalid_updates =
  updates
  |> Enum.filter(is_invalid)
  |> IO.inspect(label: "invalid", charlists: :as_lists)

get_middle = fn list ->
  Enum.at(list, div(length(list), 2))
end

fix = fn update ->
  update
  |> Enum.sort(fn a, b ->
    {a, b} in rules_both_ways
  end)
end

invalid_updates
|> Enum.map(fix)
|> IO.inspect(label: "fixed", charlists: :as_lists)
|> Enum.map(get_middle)
|> Enum.sum()
|> IO.write()
