defmodule Sphinx.Riddles.Riddle do
  @moduledoc """
    Riddle definition
  """
  use Ecto.Schema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]
  @required [:permalink, :enquirer]
  @fields [:title, :keywords, :enquirer] ++ @required

  schema "riddles" do
    field(:title, :string)
    field(:permalink, :string)
    field(:keywords, {:array, :string})
    field(:enquirer, :string)
    has_many(:answers, Sphinx.Answers.Answer)

    timestamps()
  end

  def changeset(riddle, params \\ %{}) do
    riddle
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
