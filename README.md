# BinanceHttp

Unofficial http client for binance api

## Installation

Installation from GitHub:
```elixir
def deps do
  [
    {:binance_http, git: "https://github.com/vlnic/binance_http.git", tag: "0.1"}
  ]
end
```
## Example
```elixir
BinanceHttp.Api.V3.Market.current_average_price(%{symbol: "ETHUSDT"})

{:ok, %{"mins" => 5, "price" => "2855.49383170"}}
```

## Configuration
```elixir
import Config

config :binance_http,
       secret_key: "your secret key",
       api_key: "your api key"
```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/binance_http](https://hexdocs.pm/binance_http).

