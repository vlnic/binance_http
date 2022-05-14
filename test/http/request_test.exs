defmodule BinanceHttpTest.Http.RequestTest do
  use ExUnit.Case

  alias BinanceHttp.Http.Request

  describe "common" do
    test "build_body" do
      assert Request.build_body("test", []) == "test"
      assert Request.build_body(
               %{test: "test"},
               [content_type: :json]
             ) == "{\"test\":\"test\"}"
    end

    test "build_headers" do
      assert Request.build_headers(
               [{"Content-Type", "application/json"}],
               :none
             ) == [{"Content-Type", "application/json"}]
      assert Request.build_headers([], :margin)
        == [{"X-MBX-APIKEY", Application.get_env(:binance_http, :api_key)}]
    end
  end
end
