# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :helpdesk,
  ecto_repos: [Helpdesk.Repo],
  ash_apis: [Helpdesk.Accounts.Api, Helpdesk.Tickets.Api]

config :helpdesk, Helpdesk.Repo, migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :helpdesk, HelpdeskWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4f01KRWScZ+SO5WbLzlMqO21b1btGFDCHFVjYK42qZ6z6p4IjjcyeIG9FdnwU15p",
  render_errors: [view: HelpdeskWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Helpdesk.PubSub,
  live_view: [signing_salt: "0sO236Cb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config/config.exs
config :mime, :types, %{
  "application/vnd.api+json" => ["json"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
