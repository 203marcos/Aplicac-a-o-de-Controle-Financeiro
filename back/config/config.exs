# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :trabalhoAv3,
  ecto_repos: [TrabalhoAv3.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :trabalhoAv3, TrabalhoAv3Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: TrabalhoAv3Web.ErrorHTML, json: TrabalhoAv3Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: TrabalhoAv3.PubSub,
  live_view: [signing_salt: "rX9Cb7R/"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :trabalhoAv3, TrabalhoAv3.Mailer, adapter: Swoosh.Adapters.Local


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Guardian for authentication
config :trabalhoAv3, TrabalhoAv3Web.Auth.Guardian,
  issuer: "trabalhoAv3",
  secret_key: "lQIvUK5EEZzMjOO/J68S/dW/dPHU/VpaAwfjUjQnM5XazvX4Bj1Id5T+fzOikFw9"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
