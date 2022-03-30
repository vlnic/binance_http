defmodule BinanceHttp.Api.Endpoint do
  alias BinanceHttp.Http.Query
  alias BinanceHttp.Digest

  @sign_auth_types [:trade, :margin, :user_data]

  def build(path, query, {auth, params}) when auth in @sign_auth_types do
    {signature, params} = Keyword.fetch(params, :signature)
    url = prepare_query_params(path, query)

    digest = Digest.digest(
      signature,
      Map.merge(query, %{timestamp: timestamp(), recvWindow: 10000})
    )

    if Regex.match?(~r/\?/, url) do
      url <> "&timestamp=#{digest.timestamp}&signature=#{digest.signature}"
    else
      url <> "?timestamp=#{digest.timestamp}&signature=#{digest.signature}"
    end
  end

  def build(path, query, _) when is_map(query) and map_size(query) > 0 do
    prepare_query_params(path, query)
  end

  def prepare_query_with_sign(url, params, auth) when is_map(params) do
    url
    |> prepare_query_params(params)
    |> Auth.build_signed_url(params, auth)
  end
  def prepare_query_with_sign(url, params) when is_map(params) do
    url
    |> prepare_query_params(params)
    |> add_sign(params)
  end

  def prepare_query_params(url, params) when is_map(params) do
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

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end
end
