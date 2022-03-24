defmodule BinanceHttp do
  @moduledoc """
  Documentation for `BinanceHttp`.
  """

  def config do
    Application.get_env(:binance_http, :config_module, BinanceHttp.Config)
  end
end
