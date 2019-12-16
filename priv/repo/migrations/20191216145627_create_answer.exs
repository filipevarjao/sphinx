defmodule Sphinx.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :permalink, :string, null: false
      add :upvote, :integer, default: 0
      add :solver, :string, null: false
      add :riddle_id, references(:riddles)

      timestamps()
    end
  end
end
