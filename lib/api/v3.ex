defmodule BinanceHttp.Api.V3 do
  use BinanceHttp.Api

  action :ping,
    endpoint: {:get, "/api/v3/ping"},
    auth_type: :none

  action :server_time,
    endpoint: {:get, "/api/v3/time"},
    auth_type: :none

  action :exchange_info,
    endpoint: {:get, "/api/v3/exchangeInfo"},
    auth_type: :none

  action :order_book,
    endpoint: {:get, "/api/v3/depth"},
    auth_type: :none

  action :order_book,
    endpoint: {:get, "/api/v3/depth"},
    auth_type: :none,
    params: [
      symbol: {:string},
      limit: {:integer, default: 100}
    ]
end
