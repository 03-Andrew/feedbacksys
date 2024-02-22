defmodule Feedbacksys.Repo.Migrations.CreateFeedback do
  use Ecto.Migration

  def change do
    create table(:feedback) do
      add :rating, :integer
      add :caption, :string
      add :comments, :string
      add :timestamp, :utc_datetime
      add :updated_at, :utc_datetime
      add :responsestatus, :string
      add :customer_id, references(:customer)
      add :feedback_type_id, references(:ftype)
    end
  end
end
