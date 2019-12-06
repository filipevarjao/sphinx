defmodule Sphinx.Repo.Migrations.CreateRiddle do
  use Ecto.Migration

  def change do
    create table(:riddle) do
      add :title, :string, null: true
      add :permalink, :string, null: false
      add :keywords, {:array, :string}
      add :permalink_answer, :string, null: true
      add :upvote, :integer, default: 0
      add :enquirer, :string, null: false
      add :solver, :string, null: true
    end
  end
end
