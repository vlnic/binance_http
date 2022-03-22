defmodule BinanceHttp do
  @config BinanceHttp.Config

  @moduledoc """
  Documentation for `BinanceHttp`.
  """

  def endpoint() do
    @config.get(:base_url)
  end

  def config() do
    Application.get_env(:binance_http, :config_module, BinanceHttp.Config)
  end
end
