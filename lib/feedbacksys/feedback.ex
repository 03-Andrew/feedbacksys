defmodule Feedbacksys.Feedback do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Feedbacksys.{Customer, Ftype, Feedback, Repo}


  schema "feedback" do
    field :rating, :integer
    field :caption, :string
    field :comments, :string
    field :timestamp, :utc_datetime
    field :updated_at, :utc_datetime
    field :responsestatus, :string
    belongs_to :customer_id, Customer
    belongs_to :feedback_type_id, Ftype
  end

  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, [:rating, :caption, :comments, :timestamp, :updated_at, :responsestatus])
    |> cast_assoc(:customer_id)
    |> cast_assoc(:feedback_type_id)
    |> validate_number(:rating, greater_than: 0, less_than_or_equal_to: 5)
    |> validate_length(:comments, max: 255)
  end

  def add_feedback(params \\ %{}) do
    case %Feedback{}
        |> Feedback.changeset(params)
        |> Repo.insert() do
      {:ok, _feedback} ->
        :ok
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_all_feedbacks do
    Feedback
    |> Repo.all()
    |> Repo.preload(:customer)
    |> Enum.each(&print_feedback/1)
  end

  def get_feedbacks_by_customer(customer_id) do
    Feedback
    |> where([f], f.customer_id == ^customer_id)
    |> Repo.all()
  end

  def truncate_feedback_table do
    Feedback
    |> Repo.delete_all()
  end

  defp print_feedback(feedback) do
    formatted_feedback = format_feedback(feedback)
    IO.puts(formatted_feedback)
  end

  defp format_feedback(feedback) do
    customer = feedback.customer
    rating_stars = String.duplicate("★ ", feedback.rating)
    rating_spaces = String.duplicate("☆ ", 5 - feedback.rating)
    timestamp_string = DateTime.to_string(feedback.timestamp)

    caption = "     #{feedback.caption || "No Caption"}"
    by = "     #{customer.username} (#{String.slice(timestamp_string, 0..15)})"
    rating = "     #{rating_stars}#{rating_spaces}"
    comment = "     #{feedback.comments || "No Comment"}"

    "\n#{caption}\n#{by}\n#{rating}\n#{comment}\n"
    <>"\n─────────────────────────────────────────"
  end


end
