defmodule BinanceHttp.Api.Endpoint do
  alias BinanceHttp.Digest

  @secret Application.compile_env(:binance_http, :secret_key)

  @sign_auth_types [:trade, :margin, :user_data]

  def build(path, query, auth, nil) when auth in @sign_auth_types do
    build(path, query, auth, @secret)
  end
  def build(path, query, auth, secret) when auth in @sign_auth_types do
    query = Map.merge(query, %{recvWindow: 10_000})
    url =
      base_url() <> path
      |> prepare_query_params(query)

    {signature, timestamp} = Digest.digest(secret, query)

    if Regex.match?(~r/\?/, url) do
      url <> "&timestamp=#{timestamp}&signature=#{signature}"
    else
      url <> "?timestamp=#{timestamp}&signature=#{signature}"
    end
  end

  def build(path, query, _, _) do
    base_url() <> path
    |> prepare_query_params(query)
  end

  def prepare_query_params(url, params) when is_map(params) and map_size(params) > 0 do
    params
    |> Map.to_list()
    |> Enum.reduce(url, fn ({k, v}, url) ->
      if Regex.match?(~r/\?/, url) do
        "#{url}&#{k}=#{v}"
      else
        "#{url}?#{k}=#{v}"
      end
    end)
  end

  def prepare_query_params(url, _), do: url

  defp base_url do
    Application.get_env(:binance_http, :base_url)
  end
end
