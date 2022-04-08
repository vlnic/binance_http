defmodule BinanceHttp.Api.SAPI.V1 do
  use BinanceHttp.Api

  alias BinanceHttp.Types.AccountType

  action :capital_getall,
    endpoint: {:get, "/sapi/v1/capital/config/getall"},
    auth_type: :user_data

  action :account_snapshot,
    endpoint: {:get, "/sapi/v1/accountSnapshot"},
    auth_type: :user_data,
    params: [
      type: AccountType,
      startTime: {:integer, default: nil},
      endTime: {:integer, default: nil},
      limit: {:integer, default: nil}
    ]

  action :system_status,
    endpoint: {:get, "/sapi/v1/system/status"},
    auth_type: :none

  action :disableFastWithdrawSwitch,
    endpoint: {:post, "/sapi/v1/account/disableFastWithdrawSwitch"},
    auth_type: :user_data

  action :deposit_history,
    endpoint: {:get, "/sapi/v1/capital/deposit/hisrec"},
    auth_type: :user_data,
    params: [
      coin: {:string, default: nil},
      status: {:integer, default: nil},
      startTime: {:integer, default: nil},
      endTime: {:integer, default: nil},
      offset: {:integer, default: 0},
      limit: {:integer, default: 1000}
    ]
end
