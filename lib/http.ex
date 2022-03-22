defmodule BinanceHttp.Http do
  @behaviour BinanceHttp.Behaviours.Http
  @config Application.compile_env(:binance_http, :config, BinanceHttp.Config)

  def build_url(prefix, path) do
    {:ok, @config.get(:base_url) <> "/" <> prefix <> path}
  end

  def json(url, json, headers) do
    with {:ok, body} <- Jason.encode(json),
         {:ok, body, _} <- request(:post, url, body, headers ++ ["Content-Type": "application/json"], [])
    do
      Jason.decode!(body)
    else
      {:error, %Jason.EncodeError{message: reason}} ->
        {:error, reason}

      error ->
        error
    end
  end

  def get(url, query_params, headers) do
    with {:ok, url} <- prepare_query_params(url, query_params),
         {:ok, body, _} <- request(:get, url, "", headers, [])
    do
      body
    else
      error ->
        error
    end
  end

  def request(method, url, body, headers, opts) do
    case HTTPoison.request(method, url, body, headers, opts) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        {:ok, response.body, response.headers}

      {:ok, %HTTPoison.Response{status_code: 404, request_url: req_url} = _response} ->
        {:error, :not_found, request_url: req_url}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, :unexpected_error, reason: reason}
    end
  end

  defp prepare_query_params(url, params) when is_map(params) do
    result =
      params
      |> Map.to_list()
      |> Enum.reduce(url, fn ({k, v}, url) ->
        if Regex.match?(~r/\?/, url) do
          "#{url}&#{k}=#{v}"
        else
          "#{url}?#{k}=#{v}"
        end
      end)

    {:ok, result}
  end
  defp prepare_query_params(url, _) do
    url
  end
end
