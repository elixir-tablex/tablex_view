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
      {:tablex, "~> 0.1.1-alpha.2"},
      {:makeup, "~> 1.1"},
      {:makeup_elixir, ">= 0.0.0"}
    ]
  end
end
