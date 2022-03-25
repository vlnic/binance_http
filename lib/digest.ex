defmodule BinanceHttp.Digest do
  defstruct [:signature, :timestamp]

  def digest(secret_key, %{timestamp: time} = params) when is_map(params) do
    digest(secret_key, glue_params(params), time)
  end
  def digest(_, _), do: {:error, :incorrect_params}

  defp digest(secret_key, params, timestamp) when is_binary(params) do
    signature =
      :sha256
    |> :crypto.hmac(params, secret_key)
    |> Base.encode16()
    |> String.downcase()

    %BinanceHttp.Digest{signature: signature, timestamp: timestamp}
  end
  defp digest(_, _, _), do: {:error, :incorrect_params}

  defp glue_params(%{timestamp: _} = params) when is_map(params) do
    params
    |> Map.to_list()
    |> Enum.reduce("", fn({k, v}, result) ->
      result <> "&#{k}=#{v}"
    end)
  end
end
