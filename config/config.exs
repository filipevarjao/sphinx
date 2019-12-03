use Mix.Config

config :slack, api_token: System.get_env("OAUTH_ACCESS_TOKEN")
