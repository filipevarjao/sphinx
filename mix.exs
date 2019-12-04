defmodule Sphinx.MixProject do
  use Mix.Project

  def project do
    [
      app: :sphinx,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Testing
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:slack, "~> 0.19.0"},
      {:cowboy, "~> 2.7"},
      {:plug, "~> 1.8"},
      {:plug_cowboy, "~> 2.1"},
      # Test
      {:excoveralls, "~> 0.9", only: :test}
    ]
  end
end
