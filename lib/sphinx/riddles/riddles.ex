defmodule Sphinx.Riddles do
  @moduledoc """
  Riddles
  """

  alias Sphinx.Riddles.Riddle
  alias Sphinx.Repo
  alias Sphinx.Utils.Query

  require Logger

  @spec create(map()) :: {:ok, Riddle.t()} | {:error, Ecto.Changeset.t()}
  def create(params) when is_map(params) do
    %Riddle{}
    |> Riddle.changeset(params)
    |> Repo.insert()
  end

  @spec list(map()) :: Scrivener.Page.t()
  def list(params) when is_map(params) do
    Riddle
    |> Query.q(params, [
      :id,
      :title,
      :permalink,
      :keywords,
      :enquirer
    ])
    |> Repo.paginate(params)
  end

  @spec get(map()) :: Riddle.t() | nil
  def get(%{id: id} = params) when is_map(params) do
    Repo.get_by(Riddle, id: id)
  end

  def get(%{permalink: permalink} = params) when is_map(params) do
    Repo.get_by(Riddle, permalink: permalink)
  end

  def get(_), do: nil

  @spec delete(map()) :: {:ok, Riddle.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  def delete(params) when is_map(params) do
    case get(params) do
      nil ->
        {:error, :not_found}

      riddle ->
        Repo.delete(riddle)
    end
  end

  @spec update(map()) :: {:ok, Riddle.t()} | {:error, Ecto.Changeset.t()} | {:error, :not_found}
  def update(params) when is_map(params) do
    case get(params) do
      nil ->
        {:error, :not_found}

      riddle ->
        riddle
        |> Riddle.changeset(params)
        |> Repo.update()
    end
  end
end
