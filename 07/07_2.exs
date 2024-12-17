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

  {x, _}, _ when x < 0 ->
    false

  {_, []}, _ ->
    false

  {test, numbers}, valid? ->
    [next | rest] = numbers

    IO.inspect({test, numbers}, label: "x", charlists: :as_lists)

    valid?.({test - next, rest}, valid?) or
      ((rem(test, next) == 0 && valid?.({round(test / next), rest}, valid?)) || false) or
      ((String.ends_with?(Integer.to_string(test), Integer.to_string(next)) &&
          String.length(Integer.to_string(test)) > String.length(Integer.to_string(next)) &&
          valid?.(
            {String.to_integer(
               String.replace_suffix(Integer.to_string(test), Integer.to_string(next), "")
             ), rest}
            |> IO.inspect(charlists: :as_lists),
            valid?
          )) || false)
end

input
|> IO.inspect(label: "input", charlists: :as_lists)
|> Enum.filter(&valid?.(&1, valid?))
|> Enum.map(fn {test, _} -> test end)
|> Enum.sum()
|> IO.write()
