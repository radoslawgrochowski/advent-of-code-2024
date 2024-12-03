input =
  System.argv()
  |> hd
  |> File.read!()

mul_regex = ~r/mul\(\d+,\d+\)/
muls = Regex.scan(mul_regex, input, capture: :all) |> List.flatten()

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
