defmodule TablexView.MixProject do
  use Mix.Project

  def project do
    [
      app: :tablex_view,
      version: "0.1.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      # {:tablex, "~> 0.2.0-alpha.5"},
      {:tablex, path: "../tablex"},
      {:makeup, "~> 1.1"},
      {:makeup_elixir, ">= 0.0.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
