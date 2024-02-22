defmodule Feedbacksys.Repo do
  use Ecto.Repo,
    otp_app: :feedbacksys,
    adapter: Ecto.Adapters.Postgres
end
