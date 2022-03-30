defmodule BinanceHttp.Http.Request do

  def build_body(params, [content_type: :json]) do
    Jason.encode!(params)
  end
  def build_body(params, _), do: params
end
