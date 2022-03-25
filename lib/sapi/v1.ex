defmodule BinanceHttp.SAPI.V1 do
  alias BinanceHttp.Http

  @base_path "/sapi/v1"

  def capital_detail() do
    request("/capital/config/getall", [sign: true])
  end

  def system_status() do
    request("/system/status")
  end

  defp request(path, opts \\ []) do
    with {:ok, url} <- Http.build_url(@base_path, path),
         {:ok, json} <- Http.get(url, %{}, ["Accept": "application/json"], opts),
         {:ok, response} <- Jason.decode(json)
    do
      response
    else
      error ->
        error
    end
  end
end
