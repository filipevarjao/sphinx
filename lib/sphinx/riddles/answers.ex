defmodule Sphinx.Answers do
  alias Sphinx.Riddles.Riddle
  alias Sphinx.Riddles.Answer
  alias Sphinx.Repo

  require Logger

  @spec create(map(), Riddle.t()) :: {:ok, Answer.t()} | {:error, Ecto.Changeset.t()}
  def create(params, riddle) when is_map(params) do
    riddle
    |> Ecto.build_assoc(:answers)
    |> Answer.changeset(params)
    |> Repo.insert()
  end

  @spec all(Riddle.t()) :: list()
  def all(riddle) do
    riddle
    |> Ecto.assoc(:answers)
    |> Repo.all()
  end

  @spec get(map(), Riddle.t()) :: Answer.t() | nil
  def get(%{id: id} = params, riddle) when is_map(params) do
    riddle
    |> Ecto.assoc(:answers)
    |> Repo.get_by(id: id)
  end

  def get(%{permalink: permalink} = params, riddle) when is_map(params) do
    riddle
    |> Ecto.assoc(:answers)
    |> Repo.get_by(permalink: permalink)
  end

  def get(_), do: nil

  @spec delete(map(), Riddle.t()) :: {:ok, Answer.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  def delete(params, riddle) when is_map(params) do
    case get(params, riddle) do
      nil ->
        {:error, :not_found}

      answer ->
        Repo.delete(answer)
    end
  end

  @spec update(map(), Riddle.t()) :: {:ok, Riddle.t()} | {:error, Ecto.Changeset.t()} | {:error, :not_found}
  def update(params, riddle) when is_map(params) do
    case get(params, riddle) do
      nil ->
        {:error, :not_found}

      answer ->
        answer
        |> Answer.changeset(params)
        |> Repo.update()
    end
  end
end
