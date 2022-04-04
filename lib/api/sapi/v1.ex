defmodule BinanceHttp.Api.SAPI.V1 do
  use BinanceHttp.Api

  action :capital_detail,
    endpoint: {:get, "/sapi/v1/capital/config/getall"},
    auth_type: :user_data

  action :account_snapshot,
    endpoint: {:get, "/sapi/v1/accountSnapshot"},
    auth_type: :user_data

  action :system_status,
    endpoint: {:get, "/sapi/v1/system/status"},
    auth_type: :none

  action :disableFastWithdrawSwitch,
    endpoint: {:post, "/sapi/v1/account/disableFastWithdrawSwitch"},
    auth_type: :user_data

end
