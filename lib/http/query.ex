defmodule BinanceHttp.Http.Query do
  alias BinanceHttp.Auth

  def prepare_query_with_sign(url, params) when is_map(params) do
    url
    |> prepare_query_params(params)
    |> Auth.put_signed_query(params)
  end

  def prepare_query_params(url, params) when is_map(params) do
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
  def prepare_query_params(url, _) do
    {:ok, url}
  end
end
