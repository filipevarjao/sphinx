defmodule Sphinx.Supervisor do
  @moduledoc """
  Supervisor
  """
  use Supervisor

  @token Application.get_env(:slack, :api_token)

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      Sphinx.Repo,
      %{
        id: SphinxRtm,
        start: {Slack.Bot, :start_link, [SphinxRtm, [], @token]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
