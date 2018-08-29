# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :its,
  ecto_repos: [Its.Repo]

# scrivener_html
config :scrivener_html,
  routes_helper: Its.Router.Helpers, view_style: :bootstrap_v4

# Configures the endpoint
config :its, ItsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Fnd38FJZfZnJg6O7CyzmBy6TBh3BvSPB9PDv5Gg2G2QT5gYfTOZrcYURM4sbjDng",
  render_errors: [view: ItsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Its.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
