defmodule TablexView.HorizontalView do
  alias Tablex.Table
  import HtmlEntities, only: [encode: 1]

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
      %{desc: desc, label: label, type: :undefined}, class ->
        [
          "<th class=#{class}>",
          encode(desc || label),
          "</th>"
        ]

      %{desc: desc, label: label, type: type}, class ->
        [
          "<th class=#{class}>",
          encode(desc || label),
          "<span class=stub-type>(",
          type |> to_string() |> encode(),
          ")</span></th>"
        ]
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

  for {hit_policy, text} <- Tablex.HitPolicy.hit_policies() do
    defp render_hit_policy(unquote(hit_policy)) do
      text = unquote(text)
      ~s'<th class="hit-policy hit-policy-#{text}">#{text}</th>'
    end
  end

  defp table_body(table) do
    entry_to_td = fn value, class ->
      [
        "<td class=#{class}>",
        render_exp(value),
        "</td>"
      ]
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
    "<span class=tbx-op-comp>#{comp |> to_string() |> encode()}</span><span class=tbx-exp-int>#{render_exp(value)}</span>"
  end

  defp render_exp(:any) do
    "<span class=tbx-exp-any>-</span>"
  end

  defp render_exp(true) do
    "<span class=tbx-exp-true>YES</span>"
  end

  defp render_exp(false) do
    "<span class=tbx-exp-false>NO</span>"
  end

  defp render_exp(nil) do
    "<span class=tbx-exp-null>null</span>"
  end

  defp render_exp(list) when is_list(list) do
    [
      "<span class=tbx-exp-list>",
      "<span class=tbx-square-bracket>[</span>",
      list
      |> Stream.map(&render_exp/1)
      |> Enum.intersperse("<span class=tbx-exp-list-sep>, </span>"),
      "<span class=tbx-square-bracket>]</span>",
      "</span>"
    ]
  end

  defp render_exp(exp) when is_binary(exp) do
    "<span class=tbx-exp-string>#{encode(exp)}</span>"
  end

  defp render_exp(exp) when is_integer(exp) do
    [
      "<span class='tbx-exp-number tbx-exp-int'>",
      to_string(exp),
      "</span>"
    ]
  end

  defp render_exp(exp) when is_float(exp) do
    [
      "<span class='tbx-exp-number tbx-exp-float'>",
      to_string(exp),
      "</span>"
    ]
  end

  defp render_exp({:code, "" <> code}) do
    """
    <span class=tbx-code>#{Makeup.highlight(code)}</span>
    """
  end

  defp render_exp(exp) do
    "<span class=tbx-exp>#{inspect(exp) |> encode()}</span>"
  end

  defp merge_cells(trs) do
    inputs =
      trs
      |> Enum.map(fn [_tr, _rn, inputs, _outputs, _tr_close] -> inputs end)
      |> TablexView.MergeTable.merge_cells_v()

    Stream.zip(trs, inputs)
    |> Enum.map(fn {[tr, rn, _, outputs, tr_close], inputs} ->
      [tr, rn, inputs, outputs, tr_close]
    end)
  end
end
