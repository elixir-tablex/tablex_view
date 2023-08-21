defmodule TablexView.HorizontalEditorView do
  alias Tablex.Table

  @doc """
  Render a table into HTML string.
  """
  @spec render(Table.t(), TablexView.options()) :: String.t()
  def render(%Table{} = table, opts \\ []) do
    id = Keyword.get(opts, :id, "tablex-editor")

    """
    <div id="#{id}" class="tablex-editor" data-sheet-data="#{options(table, opts) |> HtmlEntities.encode()}"></div>
    """
  end

  defp options(table, _opts) do
    %{
      data: build_data(table),
      columns: column_definitions(table),
      freezeColumns: 1
    }
    |> Jason.encode!()
  end

  defp build_data(table) do
    table.rules
    |> Enum.map(fn [n, {:input, input_entries}, {:output, output_entries}] ->
      input_cells = Enum.map(input_entries, &value_to_cell/1)
      output_cells = Enum.map(output_entries, &value_to_cell/1)
      [n] ++ input_cells ++ ["||"] ++ output_cells
    end)
  end

  defp value_to_cell(value),
    do: Tablex.Formatter.Value.render_value(value) |> IO.iodata_to_binary()

  defp column_definitions(table) do
    first_col =
      %{
        type: "numeric",
        title: TablexView.Renderer.HitPolicy.render_hit_policy(table.hit_policy)
      }

    # Default column types:
    # - text
    # - numeric
    # - hidden
    # - dropdown
    # - autocomplete
    # - checkbox
    # - radio
    # - calendar
    # - image
    # - color
    # - html
    entry_to_col_def = fn
      %{type: :string, label: label} ->
        %{
          type: "text",
          title: label,
          width: 100
        }

      %{type: type, label: label} when type in [:integer, :float, :number] ->
        %{
          type: "numeric",
          title: label,
          width: 100
        }

      %{type: :bool, label: label} ->
        %{
          type: "dropdown",
          title: label,
          source: ["yes", "no", "-"],
          width: 100
        }

      entry ->
        %{
          type: "text",
          title: entry.label,
          width: 100
        }
    end

    input_cols =
      table.inputs
      |> Enum.map(entry_to_col_def)

    separator =
      [
        %{
          type: "text",
          title: "||",
          readOnly: true,
          width: 14,
          name: "separator"
        }
      ]

    output_cols =
      table.outputs
      |> Enum.map(entry_to_col_def)

    [first_col | input_cols ++ separator ++ output_cols]
  end
end
