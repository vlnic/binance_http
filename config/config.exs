import Config

config :binance_http,
  secret: System.compile_env("SECRET_BNB_KEY"),
  api_key: System.compile_env("API_BNB_KEY"),
  base_url: System.get_env("BINANCE_ENDPOINT", "https://api.binance.com"),
  http_library: HTTPoison,
  config: BinanceHttp.Config