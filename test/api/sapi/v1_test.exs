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
end
