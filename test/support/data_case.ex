defmodule Sphinx.DataCase do
  @moduledoc """
  Module for using when want to test with database
  """
  use ExUnit.CaseTemplate

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sphinx.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Sphinx.Repo, {:shared, self()})
    end

    :ok
  end
end
