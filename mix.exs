defmodule OffersHelper.MixProject do
  use Mix.Project

  def project do
    [
      app: :offers_helper,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {OffersHelper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:topo, "~> 0.4.0"},
      {:csv, "~> 2.4"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 4.0.1"},
      {:geocalc, "~> 0.8"},
      {:table_rex, "~> 3.1.1"}
    ]
  end
end
