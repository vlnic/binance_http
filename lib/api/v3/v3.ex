defmodule BinanceHttp.Api.V3 do
  use BinanceHttp.Api

  action :ping,
    endpoint: {:get, "/api/v3/ping"},
    auth_type: :none

  action :server_time,
    endpoint: {:get, "/api/v3/time"},
    auth_type: :none

  action :order_book_ticker,
    endpoint: {:get, "/api/v3/ticker/bookTicker"},
    auth_type: :none,
    params: [
      symbol: {:string, default: nil}
    ]

  action :symbol_price_ticker,
    endpoint: {:get, "/api/v3/ticker/price"},
    auth_type: :none,
    params: [
      symbol: {:string, default: nil}
    ]

  action :ticker_price_change_statistics24hr,
    endpoint: {:get, "/api/v3/ticker/24hr"},
    auth_type: :none,
    params: [
      symbol: {:string, default: nil}
    ]
end
