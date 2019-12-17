defmodule Sphinx.Answers do
  alias Sphinx.Riddles.Riddle
  alias Sphinx.Answers.Answer
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

  @spec get(map()) :: Answer.t() | nil
  def get(%{id: id} = params) when is_map(params) do
    Repo.get_by(Answer, id: id)
  end

  def get(%{permalink: permalink} = params) when is_map(params) do
    Repo.get_by(Answer, permalink: permalink)
  end

  def get(_), do: nil

  @spec delete(map()) :: {:ok, Answer.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  def delete(params) when is_map(params) do
    case get(params) do
      nil ->
        {:error, :not_found}

      answer ->
        Repo.delete(answer)
    end
  end

  @spec update(map()) :: {:ok, Riddle.t()} | {:error, Ecto.Changeset.t()} | {:error, :not_found}
  def update(params) when is_map(params) do
    case get(params) do
      nil ->
        {:error, :not_found}

      answer ->
        answer
        |> Answer.changeset(params)
        |> Repo.update()
    end
  end
end
