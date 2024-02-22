defmodule Feedbacksys.Admin do
  use Ecto.Schema

  schema "admin" do
    field :name, :string
    field :email, :string
    field :password, :string
  end
end
