content =
  System.argv()
  |> hd
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end)

is_safe = fn levels ->
  levels
  |> Enum.reduce_while(nil, fn
    current, nil ->
      {:cont, {current, :undetermined}}

    current, {previous, _} when abs(current - previous) not in 1..3 ->
      {:halt, false}

    current, {previous, :undetermined} ->
      {:cont, {current, if(current > previous, do: :asc, else: :desc)}}

    current, {previous, :asc} when current > previous ->
      {:cont, {current, :asc}}

    current, {previous, :desc} when previous > current ->
      {:cont, {current, :desc}}

    _, _ ->
      {:halt, false}
  end)
  |> (fn result -> !!result end).()
end

is_almost_safe = fn levels ->
  is_safe.(levels) or
    levels
    |> Enum.with_index()
    |> Enum.any?(fn {_, index} ->
      is_safe.(List.delete_at(levels, index))
    end)
end

safe_count = content |> Enum.count(is_almost_safe)

IO.write(safe_count)
