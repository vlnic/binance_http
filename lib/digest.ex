defmodule BinanceHttp.Digest do
  defstruct [:signature, :timestamp]

  def digest(secret_key, params) when is_map(params) do
    time = timestamp()
    bin_params = glue_params(Map.put(params, :timestamp, time))

    signature =
      :sha256
      |> :crypto.hmac(bin_params, secret_key)
      |> Base.encode16()
      |> String.downcase()

    {signature, time}
  end
  def digest(_, _), do: {:error, :incorrect_params}

  defp glue_params(params) when is_map(params) do
    params
    |> Map.to_list()
    |> Enum.reduce("", fn({k, v}, result) ->
      result <> "&#{k}=#{v}"
    end)
  end

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end
end
