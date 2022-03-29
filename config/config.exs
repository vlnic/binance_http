import Config

config :binance_http,
  secret: System.get_env("SECRET_BNB_KEY"),
  api_key: System.get_env("API_BNB_KEY"),
  base_url: System.get_env("BINANCE_ENDPOINT", "https://api.binance.com"),
  http_library: HTTPoison,
  config: BinanceHttp.Config,
  recv_window: 10000