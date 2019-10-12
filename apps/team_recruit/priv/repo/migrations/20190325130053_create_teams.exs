defmodule TeamRecruit.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :tag, :string
      add :bio, :text
      add :nation, :string
      add :language, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:teams, [:name, :tag])
  end
end
