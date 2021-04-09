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
      extra_applications: [:logger],
      mod: {OffersHelper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:topo, "~> 0.4.0"}
    ]
  end
end
