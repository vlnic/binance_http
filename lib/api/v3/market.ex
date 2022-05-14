defmodule BinanceHttp.Api.V3.Market do
  @doc """
    Endpoints for Market Trade
  """
  use BinanceHttp.Api

  @doc """
    ### Exchange Information

    Current exchange trading rules and symbol information
    For example:

    with `symbol` param:

    BinanceHttp.Api.V3.Market.exchange_info(%{symbol: "BNBBTC"})

    with `symbols` param:

    BinanceHttp.Api.V3.Market.exchange_info(%{symbols: ["BNBBTC", "ETHUSDT"]})
  """
  action :exchange_info,
    endpoint: {:get, "/api/v3/exchangeInfo"},
    auth_type: :none,
    params: [
      symbol: {:string, default: nil},
      symbols: {{:array, :string}, default: nil}
    ]

  @doc """
    ### Order Book

    parameters:
    > symbol - string, mandatory
    > limit - integer, no mandatory (default 100)

    For example:

    BinanceHttp.Api.V3.Market.order_book(%{symbol: "ETHBTC", limit: 10})
  """
  action :order_book,
    endpoint: {:get, "/api/v3/depth"},
    auth_type: :none,
    params: [
      symbol: :string,
      limit: {:integer, default: 100}
    ]

  @doc """
    ### Recent Trades List

    parameters:
    > symbol - string, mandatory
    > limit - integer, no mandatory (default 500)

    For example:

    BinanceHttp.Api.V3.Market.recent_trades_list(%{symbol: "ETHBTC", limit: 10})
  """
  action :recent_trades_list,
    endpoint: {:get, "/api/v3/trades"},
    auth_type: :market_data,
    params: [
      symbol: :string,
      limit: {:integer, default: nil}
    ]

  @doc """
    ### Old Trade Lookup

    parameters:
    > symbol - string, mandatory
    > limit - integer, no mandatory (default 500)
    > formId - integer, no mandatory (default )

    For example:

    BinanceHttp.Api.V3.Market.recent_trades_list(%{symbol: "ETHBTC", limit: 10})
  """
  action :historical_trades,
    endpoint: {:get, "/api/v3/historicalTrades"},
    auth_type: :market_data,
    params: [
      symbol: :string,
      limit: {:integer, default: 500},
      fromId: {:integer, default: nil}
    ]

  @doc """
    ### Compressed/Aggregate Trades List

    parameters:
    > symbol - string, mandatory
    > limit - integer, no mandatory (default 500)
    > formId - integer, no mandatory (default )

    For example:

    BinanceHttp.Api.V3.Market.aggTrades(%{symbol: "ETHBTC", limit: 10})
  """
  action :aggTrades,
    endpoint: {:get, "/api/v3/aggTrades"},
    auth_type: :none,
    params: [
      symbol: :string,
      fromId: {:integer, default: nil},
      startTime: {:date_time, default: nil},
      endTime: {:date_time, default: nil},
      limit: {:integer, default: 1000}
    ]

  @doc """
    ### Current Average Price

    Current average price for a symbol.

    parameters:
    > symbol - string, mandatory,

    For example:

    BinanceHttp.Api.V3.Market.current_average_price("BNBBTC")
  """
  action :current_average_price,
    endpoint: {:get, "/api/v3/avgPrice"},
    auth_type: :none,
    params: [
      symbol: :string,
    ]
end
