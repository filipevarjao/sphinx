Application.ensure_all_started(:sphinx)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Sphinx.Repo, :manual)
