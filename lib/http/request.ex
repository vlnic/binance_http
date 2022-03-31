defmodule BinanceHttp.Http.Request do

  @api_token_auth_types [:trade, :margin, :user_data, :user_stream, :market_data]
  @api_token Application.compile_env(:binance_http, :api_token, "")

  def build_body(params, [content_type: :json]) do
    Jason.encode!(params)
  end
  def build_body(nil, _), do: ""
  def build_body(params, _), do: params

  def build_headers(headers, auth, opts) when auth in @api_token_auth_types do
    headers = headers ++ [{"X-MBX-APIKEY", @api_token}]
    content_type = Keyword.pop(opts, :content_type, "")
    headers ++ content_type_header(content_type)
  end

  def build_headers(headers, _auth, opts) do
    content_type = Keyword.pop(opts, :content_type, "")
    headers ++ content_type_header(content_type)
  end

  defp content_type_header(:json) do
    [{"Content-Type", "application/json"}]
  end
  defp content_type_header(_), do: []
end
