import Config

config :binance_http,
  secret_key: System.get_env("SECRET_BNB_KEY"),
  api_key: System.get_env("API_BNB_KEY"),
  base_url: System.get_env("BINANCE_ENDPOINT", "https://api.binance.com"),
  http_client: HTTPoison,
  config: BinanceHttp.Config,
  recv_window: 10000

import_config "#{Mix.env}.exs"
