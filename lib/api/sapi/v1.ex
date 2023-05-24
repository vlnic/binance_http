defmodule BinanceHttp.Api.SAPI.V1 do
  use BinanceHttp.Api

  alias BinanceHttp.Types.AccountType
  alias BinanceHttp.Types.UnixTimestamp

  @doc """
    ### All Coins' Information

    Get information of coins
  """
  action :capital_getall,
    endpoint: {:get, "/sapi/v1/capital/config/getall"},
    auth_type: :user_data

  action :account_snapshot,
    endpoint: {:get, "/sapi/v1/accountSnapshot"},
    auth_type: :user_data,
    params: [
      type: AccountType,
      startTime: {UnixTimestamp, default: nil},
      endTime: {UnixTimestamp, default: nil},
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
      startTime: {UnixTimestamp, default: nil},
      endTime: {UnixTimestamp, default: nil},
      offset: {:integer, default: 0},
      limit: {:integer, default: 1000}
    ]

  action :withdraw_history,
    endpoint: {:get, "/sapi/v1/capital/withdraw/history"},
    auth_type: :user_data,
    params: [
      coin: {:string, default: nil},
      withdrawOrderId: {:string, default: nil},
      status: {:string, default: nil},
      offset: {:integer, default: nil},
      limit: {:integer, default: nil},
      startTime: {UnixTimestamp, default: nil},
      endTime: {UnixTimestamp, default: nil}
    ]

  action :deposit_address,
    endpoint: {:get, "/sapi/v1/capital/deposit/address"},
    auth_type: :user_data,
    params: [
      coin: {:string, default: nil},
      network: {:string, default: nil}
    ]

  action :account_status,
    endpoint: {:get, "/sapi/v1/account/status"},
    auth_type: :user_data

  action :account_trading_status,
    endpoint: {:get, "/sapi/v1/account/apiTradingStatus"},
    auth_type: :user_data

  action :dust_log,
    endpoint: {:get, "/sapi/v1/asset/dribblet"},
    auth_type: :user_data

  action :dust_btc,
    endpoint: {:post, "/sapi/v1/asset/dust-btc"},
    auth_type: :user_data

  action :dust_transfer,
    endpoint: {:post, "/sapi/v1/asset/dust"},
    auth_type: :user_data

  action :asset_divident,
    endpoint: {:get, "/sapi/v1/asset/assetDividend"},
    auth_type: :user_data,
    params: [
      asset: {:string, default: nil},
      startTime: {UnixTimestamp, default: nil},
      endTime: {UnixTimestamp, default: nil},
      limit: {:integer, default: 20}
    ]

  action :sub_account_list,
    endpoint: {:get, "/sapi/v1/sub-account/list"},
    auth_type: :user_data,
    params: [
      email: {:string, default: nil},
      isFreeze: {:boolean, default: nil},
      page: {:integer, default: nil},
      limit: {:integer, default: nil},
      recvWindow: {:integer, default: nil},
      timestamp: {UnixTimestamp, default: nil}
    ]

  action :asset_detail,
    endpoint: {:get, "/sapi/v1/asset/assetDetail"},
    auth_type: :user_data,
    params: {:primitive, {:string, default: nil}}

  action :trade_fee,
    endpoint: {:get, " /sapi/v1/asset/tradeFee"},
    auth_type: :user_data,
    params: {:primitive, {:string, default: nil}}
end
