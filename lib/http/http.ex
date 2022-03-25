defmodule BinanceHttp.Http do
  import BinanceHttp.Http.Request, only: [put_change: 3, new: 1]

  alias BinanceHttp.Auth
  alias BinanceHttp.Http.Query
  alias BinanceHttp.Http.Request

  @behaviour BinanceHttp.Behaviours.Http
  @config Application.compile_env(:binance_http, :config, BinanceHttp.Config)

  def build_url(prefix, path) do
    {:ok, base_url() <> "/" <> prefix <> path}
  end

  def json(url, params, headers, opts \\ []) do
    with {:ok, body} <- Jason.encode(params),
         {:ok, body, _} <- request(:post, url, body, %{headers | "Content-Type": "application/json"}, opts)
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
    case request(:get, url, %{}, headers, [query: query_params]) do
      {:ok, response, _} ->
        response

      error ->
        error
    end
  end

  def request(method, url, body, headers, opts) do
    new(%{
      method: method, url: url, body: body,
      headers: headers, options: opts
    })
    |> maybe_prepare_query()
    |> maybe_put_secure_headers()
    |> maybe_prepare_body()
    |> do_request()
  end

  defp do_request(%Request{method: method, url: url, body: body, headers: headers} = _req) do
    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        {:ok, response.body, response.headers}

      {:ok, %HTTPoison.Response{status_code: 404, request_url: req_url} = _response} ->
        {:error, :not_found, request_url: req_url}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, :unexpected_error, reason: reason}
    end
  end

  defp maybe_prepare_query(%Request{url: url, options: [query: query_params, sign: true]} = request) do
    url = Query.prepare_query_with_sign(url, query_params)
    put_change(request, :url, url)
  end
  defp maybe_prepare_query(%Request{url: url, options: [query: query_params]} = request) do
    url = Query.prepare_query_params(url, query_params)
    put_change(request, :url, url)
  end
  defp maybe_prepare_query(%Request{} = request), do: request

  defp maybe_prepare_body(%Request{body: content, options: [json: true]} = request) when map_size(content) > 0 do
    body = Jason.encode(content)
    put_change(request, :body, body)
  end
  defp maybe_prepare_body(%Request{} = request), do: request

  defp maybe_put_secure_headers(%Request{headers: headers, options: [api_key: true]} = request) do
    headers = Auth.put_auth_header(headers)
    put_change(request, :headers, headers)
  end
  defp maybe_put_secure_headers(%Request{} = request), do: request

  defp base_url do
    @config.get(:base_url)
    |> String.replace_suffix("/", "")
  end
end
