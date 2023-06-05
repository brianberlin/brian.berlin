import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :brian, BrianWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "R0buF2BF6fguQcxbWl38o9DBVTSUCQoa3N1g2xdxdDVBnf0I3Y+I2qD9aHxMgaD0",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
