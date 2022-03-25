defmodule BinanceHttp.Http.Request do
  @changed_fields [:url, :headers, :options]
  @fields [:method, :url, :headers, :options, :body]

  defstruct [:method, :url, :headers, :options, :body]

  def new(params) do
    params = Map.take(params, @fields)
    struct(Request, params)
  end

  def put_change(request, key, value) when key in @changed_fields do
    request
    |> Map.from_struct
    |> Map.merge(%{key: value})
    |> new()
  end
  def put_change(request, _, _), do: request
end
