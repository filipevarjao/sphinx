defmodule Sphinx.Riddles.Riddle do
  @moduledoc """
    Riddle definition
  """
  use Ecto.Schema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime, inserted_at: :created_at]
  @required [:permalink]
  @fields [:keywords] ++ @required

  schema "riddles" do
    field(:permalink, :string)
    field(:keywords, {:array, :string})

    timestamps()
  end

  def changeset(riddle, params \\ %{}) do
    riddle
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
