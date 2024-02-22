defmodule Feedbacksys.Repo.Migrations.CreateFtype do
  use Ecto.Migration

  def change do
    create table(:ftype) do
      add :type_name, :string
    end
  end
end
