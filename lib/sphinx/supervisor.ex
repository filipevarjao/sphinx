defmodule Sphinx.Supervisor do
  @moduledoc """
  Supervisor
  """
  use Supervisor

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [Sphinx.Repo]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
