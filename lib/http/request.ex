defmodule BinanceHttp.Http.Request do
  @changed_fields [:url, :headers, :options, :body]
  @fields [:method, :url, :headers, :options, :body]

  defstruct [:method, :url, :headers, :options, :body]

  def new(params) do
    params = Map.take(params, @fields)
    struct(__MODULE__, params)
  end

  def put_change(request, key, value) when key in @changed_fields do
    IO.puts("change parameter, changed key: #{key} value: #{value}")
    request
    |> Map.from_struct()
    |> Map.put(key, value)
    |> new()
  end
  def put_change(request, _, _), do: request
end
