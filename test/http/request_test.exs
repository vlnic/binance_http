defmodule BinanceHttpTest.Http.RequestTest do
  use ExUnit.Case

  alias BinanceHttp.Http.Request

  describe "common" do
    test "#build_body" do
      assert Request.build_body("test", []) == "test"
      assert Request.build_body(
               %{test: "test"},
               [content_type: :json]
             ) == "{\"test\":\"test\"}"
    end

    test "build_headers with input api key" do
      api_key = "ZHdxaWpkdXF3aDIxOTB1ZTIx"
      assert Request.build_headers([], :margin, api_key)
        == [{"X-MBX-APIKEY", api_key}]
    end

    test "#build_headers with env api key" do
      expected_headers = [
        {"Content-Type", "application/json"},
        {"X-MBX-APIKEY", Application.get_env(:binance_http, :api_key)}
      ]
      assert Request.build_headers([{"Content-Type", "application/json"}], :margin, nil) == expected_headers
    end
  end
end
