# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :air_traffic, AirTrafficWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K4YOLfkxp65kY1f4Xtu1Uli2GG6mxdc+hexlFjD0ByL/26PACnV1bLUyXv0cu4H3",
  render_errors: [view: AirTrafficWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AirTraffic.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :air_elixir,
          airports: [{:budapest, 2}, {:dublin, 4}, {:vilnius, 1}, {:london, 7}, {:rome, 3}, {:berlin, 4}, {:barcelona, 6}],
          output_function: fn(msg) -> AirTrafficWeb.Endpoint.broadcast("planes:messages", "new-event", %{message: msg}) end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
