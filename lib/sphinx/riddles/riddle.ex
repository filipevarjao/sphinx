defmodule Sphinx.Riddles.Riddle do
  @moduledoc """
    Riddle definition
  """
  use Ecto.Schema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime, inserted_at: :created_at]
  @required [:permalink, :enquirer]
  @fields [:title, :keywords, :permalink_answer, :upvote, :enquirer, :solver] ++ @required

  schema "riddles" do
    field(:title, :string)
    field(:permalink, :string)
    field(:keywords, {:array, :string})
    field(:permalink_answer, :string)
    field(:upvote, :integer)
    field(:enquirer, :string)
    field(:solver, :string)

    timestamps()
  end

  def changeset(riddle, params \\ %{}) do
    riddle
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
