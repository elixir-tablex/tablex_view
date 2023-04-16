defmodule TablexView do
  @moduledoc """
  Documentation for `TablexView`.
  """
  alias Tablex.Table

  import HtmlEntities, only: [encode: 1]

  @hit_policies %{
    first_hit: "F",
    collect: "C",
    merge: "M",
    reverse_merge: "M"
  }

  @doc """
  Render a table into HTML string.
  """
  @spec render(Table.t()) :: String.t()
  def render(%Table{} = table) do
    [
      ~S'<table class="tablex horizontal">',
      """
      <colgroup>
      <col span="1" class="rule-number">
      <col span="#{Enum.count(table.inputs)}" class="input">
      <col span="#{Enum.count(table.outputs)}" class="output">
      </colgroup>
      """,
      table_header(table),
      table_body(table),
      "</table>"
    ]
    |> IO.iodata_to_binary()
  end

  defp table_header(table) do
    entry_to_td = fn
      %{label: label, type: :undefined}, class ->
        "<th class=#{class}>#{encode(label)}</th>"

      %{label: label, type: type}, class ->
        "<th class=#{class}>#{encode(label)} (#{type |> to_string() |> encode()})</th>"
    end

    input_tds =
      table.inputs
      |> Enum.map(&entry_to_td.(&1, "input"))

    output_tds =
      table.outputs
      |> Enum.map(&entry_to_td.(&1, "output"))

    [
      "<thead><tr>",
      render_hit_policy(table.hit_policy),
      input_tds,
      output_tds,
      "</tr></thead>"
    ]
  end

  for {hit_policy, text} <- @hit_policies do
    defp render_hit_policy(unquote(hit_policy)) do
      text = unquote(text)
      ~s'<th class="hit-policy hit-policy-#{text}">#{text}</th>'
    end
  end

  defp table_body(table) do
    entry_to_td = fn value, class ->
      "<td class=#{class}>#{render_exp(value) |> encode()}</td>"
    end

    trs =
      table.rules
      |> Enum.map(fn [n, {:input, input_entries}, {:output, output_entries}] ->
        [
          "<tr>",
          "<td class=rule-number>#{n}</td>",
          input_entries |> Enum.map(&entry_to_td.(&1, "input")),
          output_entries |> Enum.map(&entry_to_td.(&1, "output")),
          "</tr>"
        ]
      end)
      |> merge_cells()

    ["<tbody>", trs, "</tbody>"]
  end

  defp render_exp({comp, value}) when comp in ~w[< <= >= >]a do
    "#{comp}#{value}"
  end

  defp render_exp(:any) do
    "-"
  end

  defp render_exp(nil) do
    "null"
  end

  defp render_exp(list) when is_list(list) do
    Enum.map_join(list, ", ", &render_exp/1)
  end

  defp render_exp(exp) when is_binary(exp) do
    exp
  end

  defp render_exp(exp) do
    inspect(exp)
  end

  defp merge_cells(trs) do
    inputs =
      trs
      |> Enum.map(fn [_tr, _rn, inputs, _outputs, _tr_close] -> inputs end)
      |> TablexView.MergeTable.merge_cells_vertically()

    Stream.zip(trs, inputs)
    |> Enum.map(fn {[tr, rn, _, outputs, tr_close], inputs} ->
      [tr, rn, inputs, outputs, tr_close]
    end)
  end
end
