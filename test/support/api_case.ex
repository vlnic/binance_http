defmodule BinanceHttp.ApiCase do
  use ExUnit.CaseTemplate

  import Mox

  using do
    quote do
      import Mox
      import ExUnit.CaptureLog
      import BinanceHttp.ApiCase

      setup [:verify_on_exit!]
    end
  end

  def mock_client(status, response, {method, url, body, [] = headers, opts}) do
    expect(BinanceHttp.Http.ClientMock, :request, fn(recv_method, recv_url, recv_headers, recv_body, recv_opts) ->
      assert method == recv_method
      assert url == recv_url
      assert headers == recv_headers
      assert body == recv_body
      assert opts == recv_opts

      {:ok, status, [], response}
    end)
  end

  def build_url(path, params, auth_type \\ :none) do
    BinanceHttp.Api.Endpoint.build(path, params, auth_type)
  end
end
