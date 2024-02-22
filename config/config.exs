import Config

config :feedbacksys, Feedbacksys.Repo,
  database: "feedbacksys_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger, level: :info
config :ecto, loggers: [{Ecto.LogEntry, :log, :error}]

config :feedbacksys, ecto_repos: [Feedbacksys.Repo]
