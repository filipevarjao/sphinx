defmodule Sphinx.Riddles.Riddles do
  @moduledoc """
  Riddles
  """

  alias Sphinx.Riddles.Riddle
  alias Sphinx.Repo

  require Logger

  @spec create(map()) :: {:ok, Riddle.t()} | {:error, Ecto.Changeset.t()}
  def create(params) when is_map(params) do
    %Riddle{}
    |> Riddle.changeset(params)
    |> Repo.insert()
  end
end
