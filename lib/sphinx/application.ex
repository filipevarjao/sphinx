defmodule Sphinx.Application do
  @moduledoc """
  Sphinx application behaviour
  """

  use Application

  @impl true
  def start(_, _) do
    Sphinx.Supervisor.start_link()
  end
end
