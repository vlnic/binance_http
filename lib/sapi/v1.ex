defmodule BinanceHttp.SAPI.V1 do
  alias BinanceHttp.Http
  alias BinanceHttp.Auth

  @base_path "/sapi/v1"

  def capital_detail(%{auth: %{api_key: key, secret_key: secret} = auth}) do
    request("/capital/config/getall", %{}, [sign: true, auth: auth])
  end
  def capital_detail() do
    request("/capital/config/getall", %{}, [sign: true])
  end

  def account_snapshot(%{params: %{type: type} = snapshot_params} = request) when type in ["SPOT", "MARGIN", "FUTURES"] do
    query_params = Map.take(snapshot_params, [:type, :start_time, :end_time, :limit])
    case Map.fetch(request, :auth) do
      {:ok, auth} ->
        request("/accountSnapshot", query_params, [auth: auth, sign: true])

      _error ->
        request("/accountSnapshot", query_params, [sign: true])
    end
  end
  def account_snapshot(_), do: {:error, :incorrect_params}

  def system_status() do
    request("/system/status")
  end

  defp request(path, query, opts \\ []) do
    with {:ok, url} <- Http.build_url(@base_path, path),
         {:ok, json} <- Http.get(url, query, [{"Accept", "application/json"}], opts),
         {:ok, response} <- Jason.decode(json)
    do
      response
    else
      error ->
        error
    end
  end
end
