defmodule Sphinx.MixProject do
  use Mix.Project

  def project do
    [
      app: :sphinx,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
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

  def application do
    [
      extra_applications: [:logger],
      mod: {Sphinx.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.2"},
      {:scrivener_ecto, "~> 2.2"},
      {:postgrex, "~> 0.15.2"},
      {:slack, "~> 0.19.0"},
      {:cowboy, "~> 2.7"},
      {:plug, "~> 1.8"},
      {:plug_cowboy, "~> 2.1"},
      # Test
      {:excoveralls, "~> 0.9", only: :test},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create --quiet", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test --no-start"]
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/support"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths(), do: ["lib"]
end
