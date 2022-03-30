defmodule BinanceHttp.Http.Query do
  alias BinanceHttp.Auth

  # @TODO delete this
  def prepare_query_with_sign(url, params, auth) when is_map(params) do
    url
    |> prepare_query_params(params)
    |> Auth.build_signed_url(params, auth)
  end
  def prepare_query_with_sign(url, params) when is_map(params) do
    url
    |> prepare_query_params(params)
    |> Auth.build_signed_url(params)
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
end
