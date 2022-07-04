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

  def mock_client(status, response, {method, _url, body, headers, opts}) do
    expect(BinanceHttp.Http.ClientMock, :request, fn(recv_method, _recv_url, recv_body, recv_headers, recv_opts) ->
      assert method == recv_method
      assert headers == recv_headers
      assert body == recv_body
      assert opts == recv_opts

      {:ok, %{status_code: status, body: response, headers: [{"Content-Type", "application/json"}]}}
    end)
  end

  def build_url(path, params, auth_type \\ :none, secret \\ "") do
    BinanceHttp.Api.Endpoint.build(path, params, auth_type, secret)
  end
end
