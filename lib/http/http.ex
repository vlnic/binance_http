defmodule BinanceHttp.Http do
  alias BinanceHttp.Auth
  alias BinanceHttp.Http.Query
  alias BinanceHttp.Http.Request

  @client Application.compile_env(:binance_http, :http_client, HTTPoison)

  def request(method, url, body, headers, opts) do
    case @client.request(method, url, body, headers, opts) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        {:ok, response.body, response.headers}

      {:ok, %HTTPoison.Response{status_code: 404, request_url: req_url} = _response} ->
        {:error, :not_found, request_url: req_url}

      {:ok, %HTTPoison.Response{status_code: 400} = response} ->
        {:error, :invalid_request, response: response}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, :unexpected_error, reason: reason}
    end
  end

  defp base_url do
    @config.get(:base_url)
    |> String.replace_suffix("/", "")
  end
end
