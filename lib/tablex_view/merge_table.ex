defmodule TablexView.MergeTable do
  def merge_cells_v(table) do
    {w, h} = size(table)
    map = to_map(table)

    map =
      1..h
      |> Enum.reduce(map, fn y, map ->
        1..w
        |> Enum.reduce_while(map, fn x, map ->
          v = Map.get(map, {x, y})

          case Map.get(map, {x, y - 1}) do
            ^v ->
              map =
                map
                |> Map.put({x, y}, {:merged, v})

              {:cont, map}

            {:merged, ^v} ->
              map =
                map
                |> Map.put({x, y}, {:merged, v})

              {:cont, map}

            _ ->
              {:halt, map}
          end
        end)
      end)

    1..h
    |> Enum.map(fn y ->
      1..w
      |> Enum.flat_map(fn x ->
        case Map.get(map, {x, y}) do
          {:merged, _} ->
            []

          item ->
            case count_span_v(map, {x, y}, item) do
              1 ->
                [item]

              x when is_integer(x) ->
                [td_open | rest] = item
                [String.replace(td_open, "<td ", "<td rowspan=#{x} ") | rest]
            end
        end
      end)
    end)
  end

  defp size([row | _] = table) do
    {Enum.count(row), Enum.count(table)}
  end

  defp to_map(table) do
    Stream.with_index(table, 1)
    |> Stream.flat_map(fn {row, y} ->
      Stream.with_index(row, 1)
      |> Enum.map(fn {cell, x} ->
        {{x, y}, cell}
      end)
    end)
    |> Enum.into(%{})
  end

  defp count_span_v(map, {x, y}, item) do
    case Map.get(map, {x, y + 1}) do
      {:merged, ^item} ->
        1 + count_span_v(map, {x, y + 1}, item)

      _ ->
        1
    end
  end

  defp count_span_h(map, {x, y}, item) do
    case Map.get(map, {x + 1, y}) do
      {:merged, ^item} ->
        1 + count_span_h(map, {x + 1, y}, item)

      _ ->
        1
    end
  end

  def merge_cells_h(table) do
    {w, h} = size(table)
    map = to_map(table)

    map =
      1..w
      |> Enum.reduce(map, fn x, map ->
        1..h
        |> Enum.reduce_while(map, fn y, map ->
          v = Map.get(map, {x, y})

          case Map.get(map, {x - 1, y}) do
            ^v ->
              map =
                map
                |> Map.put({x, y}, {:merged, v})

              {:cont, map}

            {:merged, ^v} ->
              map =
                map
                |> Map.put({x, y}, {:merged, v})

              {:cont, map}

            _ ->
              {:halt, map}
          end
        end)
      end)

    1..h
    |> Enum.map(fn y ->
      1..w
      |> Enum.flat_map(fn x ->
        case Map.get(map, {x, y}) do
          {:merged, _} ->
            []

          item ->
            case count_span_h(map, {x, y}, item) do
              1 ->
                [item]

              x when is_integer(x) ->
                [td_open | rest] = item
                [String.replace(td_open, "<td", "<td colspan=#{x}") | rest]
            end
        end
      end)
    end)
  end
end
