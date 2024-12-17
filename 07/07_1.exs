input =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    [test, numbers] = String.split(line, ":", trim: true)

    {
      String.to_integer(test),
      String.split(numbers, "\s", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.reverse()
    }
  end)

valid? = fn
  {x, y}, _ when length(y) === 1 ->
    x == Enum.at(y, 0)

  {0, []}, _ ->
    true

  {_, []}, _ ->
    false

  {test, numbers}, valid? ->
    [next | rest] = numbers

    valid?.({test - next, rest}, valid?) or
      (rem(round(test), next) == 0 && valid?.({test / next, rest}, valid?)) || false
end

input
|> IO.inspect(label: "input", charlists: :as_lists)
|> Enum.filter(&valid?.(&1, valid?))
|> Enum.map(fn {test, _} -> test end)
|> Enum.sum()
|> IO.write()
