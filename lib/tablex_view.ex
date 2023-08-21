defmodule TablexView do
  @moduledoc """
  Documentation for `TablexView`.
  """
  alias Tablex.Table

  @type options() :: [option()]
  @type option() :: {:mode, mode()}
  @type mode() :: :html_table | :editor

  @doc """
  Renders a table to HTML view.
  """
  @spec render(Table.t(), options()) :: String.t()
  def render(table, opts \\ [])

  def render(%Table{} = table, opts) do
    {mode, opts} = Keyword.pop(opts, :mode, :html_table)

    case mode do
      :html_table ->
        TablexView.HorizontalView.render(table, opts)

      :editor ->
        TablexView.HorizontalEditorView.render(table, opts)
    end
  end

  @doc """
  Render default stylesheets.
  """
  @spec stylesheet(options()) :: String.t()
  def stylesheet(opts \\ []) do
    TablexView.Stylesheet.css(opts)
  end
end
