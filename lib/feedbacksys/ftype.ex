defmodule Feedbacksys.Ftype do
  alias Feedbacksys.{Repo, Ftype}
  use Ecto.Schema
  import Ecto.Changeset

  schema "ftype" do
    field :type_name, :string
  end


  def changeset(ftype, params \\ %{}) do
    ftype
    |> cast(params, [:type_name])
  end

  def get_all_types do
    Ftype
    |> Repo.all()
    |> Enum.each(&print_types/1)
  end

  defp print_types(type) do
    formatted_type = format_type(type)
    IO.puts(formatted_type)
  end

  defp format_type(type) do
    "   (#{type.id}) #{type.type_name}"
  end

  def add_type(params \\ %{}) do
    %Ftype{}
    |> changeset(params)
    |> Repo.insert()
  end
end
