defmodule Sphinx.Repo.Migrations.CreateRiddle do
  use Ecto.Migration

  def change do
    create table(:riddles) do
      add :title, :string, null: true
      add :permalink, :string, null: false
      add :keywords, {:array, :string}
      add :enquirer, :string, null: false
      add :created_at, :utc_datetime, default: fragment("NOW()")

      timestamps()
    end
  end
end
