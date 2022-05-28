defmodule BinanceHttp.Http.Request do

  @api_token_auth_types [:trade, :margin, :user_data, :user_stream, :market_data]
  @api_token Application.compile_env(:binance_http, :api_key)

  def build_body(params, [content_type: :json]) do
    Jason.encode!(params)
  end
  def build_body(params, _) when is_binary(params), do: params
  def build_body(_, _), do: ""

  def build_headers(headers, auth, nil) when auth in @api_token_auth_types do
    build_headers(headers, auth, @api_token)
  end
  def build_headers(headers, auth, api_token) when auth in @api_token_auth_types do
    headers ++ [{"X-MBX-APIKEY", api_token}]
  end
  def build_headers(headers, _auth, _), do: headers
end
