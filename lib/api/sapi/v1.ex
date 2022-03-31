defmodule BinanceHttp.Api.SAPI.V1 do
  use BinanceHttp.Api

  request :capital_detail,
    endpoint: {:get, "/sapi/v1/capital/config/getall"},
    auth_type: :user_data

  request :account_snapshot,
    endpoint: {:get, "/sapi/v1/accountSnapshot"},
    auth_type: :user_data

  request :system_status,
    endpoint: {:get, "/sapi/v1/system/status"},
    auth_type: :none
end
