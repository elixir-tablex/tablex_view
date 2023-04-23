defmodule TablexView do
  @moduledoc """
  Documentation for `TablexView`.
  """
  alias Tablex.Table

  def render(%Table{table_dir: :v} = table) do
    TablexView.VerticalView.render(table)
  end

  def render(%Table{} = table) do
    TablexView.HorizontalView.render(table)
  end

  def stylesheet do
    TablexView.Stylesheet.css()
  end
end
