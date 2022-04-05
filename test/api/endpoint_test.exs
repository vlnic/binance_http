defmodule BinanceHttpTest.Api.EndpointTest do
  use ExUnit.Case

  alias BinanceHttp.Api.Endpoint

  describe "common" do
    test "build without signature" do
      path = "/example/path"

      assert "https://localhost#{path}" == Endpoint.build(path, %{}, :none)
    end

    test "build with query params" do
      path = "/example/path"

      assert "https://localhost#{path}?test=1" == Endpoint.build(path, %{test: 1}, :none)
    end

    test "build with query params and sign" do
      path = "/example/path"
      url = Endpoint.build(path, %{test: "test"}, :user_data)

      assert String.contains?(url, ["test=test", "timestamp=", "signature="])
    end
  end
end
