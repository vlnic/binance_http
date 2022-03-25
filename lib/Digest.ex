defmodule BinanceHttp.Digest do
  defstruct [:signature, :timestamp]

  def digest(secret_key, params) when is_map(params) do
    digest(secret_key, glue_params(params))
  end
  def digest(secret_key, params) when is_binary(params) do
    :sha256
    |> :crypto.hmac(params, secret_key)
    |> Base.encode16()
    |> String.downcase()
  end
  def digest(_, _), do: {:error, :incorrect_params}

  defp glue_params(%{timestamp: _} = params) when is_map(params) do
    params
    |> Map.to_list()
    |> Enum.reduce("", fn({k, v}, result) ->
      result <> "&#{k}=#{v}"
    end)
  end
end
