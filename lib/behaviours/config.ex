defmodule BinanceHttp.Behaviours.Config do

  @callback get(key :: String.t() | atom(), key :: any()) :: any()
end
