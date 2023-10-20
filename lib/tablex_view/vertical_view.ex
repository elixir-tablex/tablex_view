defmodule TablexView.VerticalView do
  alias Tablex.Table
  alias TablexView.MergeTable

  import HtmlEntities, only: [encode: 1]

  @doc """
  Render a table into HTML string.

  ```tablex
  ====
  F                    || 1                        2                       3
  "Product Category"   || Electronics              "Home Goods"            Fashion
  "Competitor Pricing" || "Higher than Competitor" "Lower than Competitor" "Same as Competitor"
  "Product Features"   || "More Features"          "Same Features"         "New Features"
  ====
  "Launch Decision"    || Launch                   Launch                  "Do Not Launch"
  Reasoning            || "Competitive Advantage"  "Price Advantage"       "Lack of Differentiation"
  ```
  """

  @spec render(Table.t()) :: String.t()
  def render(%Table{} = table) do
    [
      ~S'<table class="tablex vertical">',
      table_header(table),
      table_body(table),
      table_foot(table),
      "</table>"
    ]
    |> IO.iodata_to_binary()
  end

  defp table_header(table) do
    [
      "<thhead>",
      render_hit_policy(table.hit_policy),
      render_rule_numbers(table),
      "</thead>"
    ]
  end

  for {hit_policy, text} <- Tablex.HitPolicy.hit_policies() do
    defp render_hit_policy(unquote(hit_policy)) do
      text = unquote(text)
      ~s'<th class="hit-policy hit-policy-#{text}">#{text}</th>'
    end
  end

  defp render_rule_numbers(%{rules: rules}) do
    Enum.map(rules, fn [n | _] ->
      ["<th class=rule-number>", to_string(n), "</th>"]
    end)
  end

  defp table_body(table) do
    [
      "<tbody>",
      render_input_rows(table),
      "</tbody>"
    ]
  end

  defp render_input_rows(%{inputs: in_def, rules: rules}) do
    in_val =
      rules
      |> Stream.map(fn [_n, {:input, conditions} | _] -> conditions end)
      |> Stream.zip()
      |> Enum.map(fn conditions ->
        conditions
        |> Tuple.to_list()
        |> Enum.map(fn val ->
          ["<td>", render_exp(val), "</td>"]
        end)
      end)
      |> MergeTable.merge_cells_h()

    Stream.zip(in_def, in_val)
    |> Enum.map(fn {in_def, tds} ->
      [
        "<tr>",
        ["<th class=input>", entry_to_td(in_def), "</th>"],
        tds,
        "</tr>"
      ]
    end)
  end

  defp entry_to_td(%{desc: desc, label: label, type: :undefined}) do
    encode(desc || label)
  end

  defp entry_to_td(%{desc: desc, label: label, type: type}) do
    [
      encode(desc || label),
      "<span class=stub-type>(",
      type |> to_string() |> encode(),
      ")</span>"
    ]
  end

  defp table_foot(table) do
    [
      "<tfoot>",
      render_output_rows(table),
      "</tfoot>"
    ]
  end

  defp render_exp({comp, value}) when comp in ~w[< <= >= >]a do
    "<span class=tbx-op-comp>#{encode(comp)}</span><span class=tbx-exp-int>#{encode(value)}</span>"
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

  defp render_output_rows(%{outputs: defs, rules: rules}) do
    values =
      rules
      |> Stream.map(fn [_n, _input, {:output, values} | _] -> values end)
      |> Stream.zip()
      |> Stream.map(&Tuple.to_list/1)

    Stream.zip(defs, values)
    |> Enum.map(fn {entry, entry_values} ->
      [
        "<tr>",
        ["<th class=output>", entry_to_td(entry), "</th>"],
        Enum.map(entry_values, fn val ->
          ["<td>", render_exp(val), "</td>"]
        end),
        "</tr>"
      ]
    end)
  end
end
