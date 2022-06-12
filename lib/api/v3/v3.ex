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

  action :new_order,
    endpoint: {:post, "/api/v3/order"},
    auth_type: :trade,
    params: [
      symbol: :string,
      side: :string,
      type: :string,
      timeInForce: {:string, default: nil},
      quantity: {:float, default: nil},
      quoteOrderQty: {:float, default: nil},
      price: {:float, default: nil},
      newClientOrderId: {:string, default: nil},
      stopPrice: {:float, default: nil},
      trailingDelta: {:float, default: nil},
      icebergQty: {:float, default: nil},
      newOrderRespType: {:string, default: "FULL"},
      recvWindow: {:integer, default: nil}
    ]

  action :cancel_order,
    endpoint: {:delete, "/api/v3/order"},
    auth_type: :trade,
    params: [
      symbol: :string,
      orderId: {:integer, default: nil},
      origClientOrderId: {:string, default: nil},
      newClientOrderId: {:string, default: nil}
    ]

  action :cancel_all_orders,
    endpoint: {:delete, "/api/v3/openOrders"},
    auth_type: :trade,
    params: [
      symbol: :string
    ]

  action :query_order,
    endpoint: {:get, "/api/v3/order"},
    auth_type: :user_data,
    params: [
      symbol: :string,
      orderId: {:integer, default: nil},
      origClientOrderId: {:string, default: nil}
    ]

  action :open_orders,
    endpoint: {:get, "/api/v3/openOrders"},
    auth_type: :user_data,
    params: [
      symbol: {:string, default: nil}
    ]

  action :all_orders,
    endpoint: {:get, "/api/v3/allOrders"},
    auth_type: :user_data,
    params: [
      symbol: :string,
      orderId: {:integer, default: nil},
      startTime: {:integer, default: nil},
      endTime: {:integer, default: nil},
      limit: {:integer, default: nil}
    ]
end
