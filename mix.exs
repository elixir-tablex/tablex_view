defmodule TablexView.MixProject do
  use Mix.Project

  def project do
    [
      app: :tablex_view,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:html_entities, "~> 0.5"},
      {:tablex, "~> 0.3.1"},
      {:makeup, "~> 1.1"},
      {:makeup_elixir, ">= 0.0.0"},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "tablex",
      description: "Viewer for Tablex",
      files: ~w[lib mix.exs],
      licenses: ~w[MIT],
      links: %{
        "Github" => "https://github.com/elixir-tablex/tablex_view"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ~w[
        README.md
        ],
      source_url: "https://github.com/elixir-tablex/tablex_view"
    ]
  end
end
