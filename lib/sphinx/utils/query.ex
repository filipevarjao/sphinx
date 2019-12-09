defmodule Sphinx.Utils.Query do
  @moduledoc """
  Utils for Ecto queries
  """
  import Ecto.Query

  def q(schema, params, permitted) do
    conditions = build_conditions(params, permitted)
    from(schema, where: ^conditions)
  end

  ## Private functions

  defp build_conditions(params, permitted) do
    params
    |> Map.take(permitted)
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.reduce(true, fn {field, value}, acc ->
      dynamic([q], field(q, ^field) == ^value and ^acc)
    end)
  end
end
