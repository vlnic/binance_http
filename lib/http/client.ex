defmodule BinanceHttp.Http.Client do
  @doc """
    Abstraction for integrate http client
  """

  @callback request(method :: binary, url :: binary, body :: term,
              headers :: list, opts :: list)
  :: {:ok, status :: non_neg_integer, headers :: list | map, body :: nil | binary}
  | {:error, term}

  def request(method, url, body, headers, opts) do
    case impl().request(method, url, body, headers, opts) do
      {:ok, %{status_code: 200, body: body, headers: headers}} ->
        {:ok, body, headers}

      {:ok, %{status_code: 404, request_url: req_url} = _response} ->
        {:error, :not_found, request_url: req_url}

      {:ok, %{status_code: 400} = response} ->
        {:error, :invalid_request, response: response}

      {:error, %{reason: reason}} ->
        {:error, :unexpected_error, reason: "error: #{inspect(reason)}", error_data: reason}
    end
  end

  defp impl, do: Application.get_env(:binance_http, :http_client, HTTPoison)
end
