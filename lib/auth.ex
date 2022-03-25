defmodule BinanceHttp.Auth do
  alias BinanceHttp.Config
  alias BinanceHttp.Digest

  @config Config

  defstruct [:api_key, :secret_key]

  def put_auth_header(headers) do
    headers ++ ["X-MBX-APIKEY": auth_params().api_key]
  end

  def put_signed_query(url, query_params) do
    auth = auth_params()
    digest = Digest.digest(auth.secret_key, %{query_params | timestamp: timestamp()})

    if Regex.match?(~r/\?/, url) do
      url <> "&timestamp=#{digest.timestamp}&signature=#{digest.signature}"
    else
      url <> "?timestamp=#{digest.timestamp}&signature=#{digest.signature}"
    end
  end

  defp auth_params do
    %Auth{
      api_key: api_key(),
      secret_key: @config.get(:secret_key)
    }
  end

  defp timestamp do
    DateTime.now()
    |> DateTime.to_unix()
  end
end
