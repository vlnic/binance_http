defmodule BinanceHttp.Http.Request do
  # @TODO delete this
  @changed_fields [:url, :headers, :options]
  @fields [:method, :url, :headers, :options]

  defstruct [:method, :url, :headers, :options]

  def new(params) do
    params = Map.take(params, @fields)
    struct(__MODULE__, params)
  end

  def put_change(request, key, value) when key in @changed_fields do
    request
    |> Map.from_struct()
    |> Map.put(key, value)
    |> new()
  end
  def put_change(request, _, _), do: request
end
