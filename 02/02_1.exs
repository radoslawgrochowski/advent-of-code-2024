content =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.split(line, " ", trim: true)
    |> Enum.map(fn string -> String.to_integer(string) end)
  end)

is_safe = fn levels ->
  levels
  |> Enum.reduce_while(nil, fn
    current, {previous, _} when abs(current - previous) not in 1..3 ->
      {:halt, false}

    current, {previous, :undetermined} ->
      {:cont, {current, if(current > previous, do: :asc, else: :desc)}}

    current, {previous, :asc} when current > previous ->
      {:cont, {current, :asc}}

    current, {previous, :desc} when previous > current ->
      {:cont, {current, :desc}}

    current, nil ->
      {:cont, {current, :undetermined}}

    _, _ ->
      {:halt, false}
  end)
end

safe_count = content |> Enum.count(is_safe)

IO.write(safe_count)
