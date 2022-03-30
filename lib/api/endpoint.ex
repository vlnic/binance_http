defmodule BinanceHttp.Api.Endpoint do
  alias BinanceHttp.Http.Query
  alias BinanceHttp.Digest

  @secret Application.compile_env(:binance_http, :secret_key)
  @base_url Application.get_env(:binance_http, :base_url)

  @sign_auth_types [:trade, :margin, :user_data]

  def build(path, query, auth) when auth in @sign_auth_types do
    url = @base_url <> path
          |> prepare_query_params(query)

    {signature, timestamp} = Digest.digest(
      @secret,
      Map.merge(query, %{recvWindow: 10000})
    )

    if Regex.match?(~r/\?/, url) do
      url <> "&timestamp=#{timestamp}&signature=#{signature}"
    else
      url <> "?timestamp=#{timestamp}&signature=#{signature}"
    end
  end

  def build(path, query, _) do
    prepare_query_params(path, query)
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
end
