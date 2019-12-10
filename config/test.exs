use Mix.Config

config :slack, api_token: System.get_env("OAUTH_ACCESS_TOKEN")

config :sphinx, ecto_repos: [Sphinx.Repo]

config :sphinx, Sphinx.Repo,
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  database: "sphinx_test",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox
