defmodule BinanceHttpTest.Api.SAPI.V1Test do
  use BinanceHttp.ApiCase, async: false

  describe "#capital_getall" do
    test "returns successful" do
      headers = [{"X-MBX-APIKEY", Application.get_env(:binance_http, :api_key)}]
      request =
        {:get, build_url("/sapi/v1/capital/config/getall", %{}, :user_data), "", headers, []}

      mock_client(200, Jason.encode!([%{coin: "BTC", free: "0.08074558"}]), request)

      assert {:ok, [%{"coin" => "BTC", "free" => "0.08074558"}]} == BinanceHttp.Api.SAPI.V1.capital_getall()
    end
  end

  describe "#account_snapshot" do
    test "common" do
      start = DateTime.utc_now() |> DateTime.to_unix(:second)
      endTime = DateTime.utc_now()
                |> DateTime.add(7200, :second)
                |> DateTime.to_unix()
      headers = [{"X-MBX-APIKEY", Application.get_env(:binance_http, :api_key)}]
      query_params = %{type: "SPOT", startTime: start, endTime: endTime, limit: 50}
      request = {
        :get,
        build_url("/sapi/v1/accountSnapshot", query_params, :user_data),
        "",
        headers,
        []
      }
      response = %{
        "code" => 200,
        "msg" => "",
        "snapshotVos" => [
          %{
            "data" => %{
              "balances" => [
                %{
                  "asset" => "USDT",
                  "free" => "1.89109409",
                  "locked" => "0.00000000"
                }
              ],
              "type" => "spot",
              "updateTime" => ""
            }
          }
        ]
      }

      mock_client(200, Jason.encode!(response), request)

      {:ok, response} == BinanceHttp.Api.SAPI.V1.account_snapshot(query_params)
    end
  end
end
