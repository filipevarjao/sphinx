use Mix.Config

config :slack, api_token: System.get_env("OAUTH_ACCESS_TOKEN")

config :sphinx,
  ecto_repos: [Sphinx.Repo],
  port: String.to_integer(System.get_env("PORT") || "8080")

config :sphinx, Sphinx.Repo,
  hostname: System.get_env("PG_HOST") || "localhost",
  username: System.get_env("PG_USERNAME") || "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  database: System.get_env("PG_DATABASE") || "sphinx",
  port: String.to_integer(System.get_env("PG_PORT") || "5432")
