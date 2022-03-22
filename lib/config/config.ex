defmodule BinanceHttp.Config do
  @behaviour BinanceHttp.Behaviours.Config

  def get(key, default \\ nil) do
    Application.get_env(:binance_http, key, default)
  end
end
