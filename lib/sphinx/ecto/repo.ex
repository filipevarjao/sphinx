defmodule Sphinx.Repo do
  use Ecto.Repo,
    otp_app: :sphinx,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
