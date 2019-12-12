Application.ensure_all_started(:sphinx)
ExUnit.configure(exclude: :pending)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Sphinx.Repo, :manual)
