defmodule Feedbacksys.Customer do
  alias Feedbacksys.{Customer, Repo}
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "customer" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :password, :string
  end

  @doc false
  def changeset(customer, params) do
    customer
    |> cast(params, [:name, :username, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 2, max: 100)
  end

  def add_customer(params \\ %{}) do
    %Customer{}
    |> Customer.changeset(params)
    |> Repo.insert()
  end

  def delete_customer_by_id(customer_id) do
    case Repo.get(Customer, customer_id) do
      nil ->
        {:error, "Customer not found"}
      customer ->
        Repo.delete(customer)
        {:ok, "Customer deleted successfully"}
    end
  end


  def edit_customer_field(customer_id, field, value) do
    customer = Repo.get(Customer, customer_id)
    case customer do
      nil ->
        {:error, "Customer not found"}
      _ ->
        changeset = Customer.changeset(customer, %{field => value})

        case Repo.update(changeset) do
          {:ok, _updated_customer} ->
            {:ok, "Successfully updated"}
          {:error, _changeset} ->
            if not String.match?(value, ~r/@/), do: IO.puts("Email has no '@'")
        end
    end
  end

  def change_password(customer, old_pass, new_pass) do
    case old_pass == new_pass do
      true ->
          case customer do
        nil ->
          {:error, "Customer not found"}
        _ ->
          changeset = Customer.changeset(customer, %{:password => new_pass})

          case Repo.update(changeset) do
            {:ok, _updated_customer} ->
              {:ok, "Successfully updated"}
            {:error, changeset} ->
              {:error, changeset}
          end
      end
      false ->
        {:error, "Incorrect old password"}
    end
  end



  def get_all_customers do
    Repo.all(Customer)
  end

  def get_customer_by_email(email) do
    from(c in Customer, where: c.email == ^email) |> Repo.one()
  end

end
