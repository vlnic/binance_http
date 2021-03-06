defmodule BinanceHttp.Digest do
  defstruct [:signature, :timestamp]

  def digest(secret_key, params) when is_map(params) do
    time = timestamp()
    bin_params = glue_params(Map.put(params, :timestamp, time))

    signature =
      :hmac
      |> :crypto.mac(:sha256, secret_key, bin_params)
      |> Base.encode16(case: :lower)

    {signature, time}
  end
  def digest(_, _), do: {:error, :incorrect_params}

  defp glue_params(params) when is_map(params) do
    params
    |> Map.to_list()
    |> Enum.reduce("", fn({k, v}, result) ->
      result <> "&#{k}=#{v}"
    end)
    |> String.trim("&")
  end

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix(:millisecond)
  end
end
