input =
  System.argv()
  |> hd
  |> File.read!()

mul_regex = ~r/mul\(\d+,\d+\)/
do_regex = ~r/(do|don't)\(\)/

dos2 =
  (["do()"] ++ String.split(input, do_regex, include_captures: true))
  |> Enum.chunk_every(2)
  |> Enum.flat_map(fn
    ["do()", right] -> [right]
    _ -> []
  end)
  |> Enum.join()

muls = Regex.scan(mul_regex, dos2, capture: :all) |> List.flatten()

parsed =
  muls
  |> Enum.map(fn x ->
    String.split(x, ",")
    |> Enum.map(&String.replace(&1, ~r/\D/, ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(fn el, acc -> acc * el end)
  end)
  |> Enum.sum()

IO.write(parsed)
