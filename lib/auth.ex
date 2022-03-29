defmodule BinanceHttp.Auth do
  alias BinanceHttp.Config
  alias BinanceHttp.Digest

  @config Config
  @default_recv_window 10000

  defstruct [:api_key, :secret_key]

  # @TODO fix put headers
  def put_auth_header(headers) do
    headers ++ ["X-MBX-APIKEY": auth_params().api_key]
  end

  def put_auth_header(headers, %{api_key: key} = _auth) do
    headers ++ ["X-MBX-APIKEY": key]
  end

  def build_signed_url(url, query_params, auth) do
    build_url(url, query_params, auth)
  end

  def build_signed_url(url, query_params) do
    build_url(url, query_params, auth_params())
  end


  defp build_url(url, query, auth) do
    digest = Digest.digest(
      auth.secret_key,
      Map.merge(query, %{timestamp: timestamp(), recvWindow: @default_recv_window})
    )

    if Regex.match?(~r/\?/, url) do
      url <> "&timestamp=#{digest.timestamp}&signature=#{digest.signature}"
    else
      url <> "?timestamp=#{digest.timestamp}&signature=#{digest.signature}"
    end
  end

  defp auth_params do
    %__MODULE__{
      api_key: @config.get(:api_key),
      secret_key: @config.get(:secret_key)
    }
  end

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end
end
