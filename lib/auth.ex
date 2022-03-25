defmodule BinanceHttp.Auth do
  alias BinanceHttp.Config
  alias BinanceHttp.Digest

  @config Config

  defstruct [:api_key, :secret_key]

  def put_auth_header(headers) do
    headers ++ ["X-MBX-APIKEY": auth_params().api_key]
  end

  def put_signed_query(url, %Auth{} = auth, query_params) do
    digest = Digest.digest(auth.secret_key, %{query_params | timestamp: timestamp()})
    url <> "&timestamp=#{digest.timestamp}&#{digest.signature}"
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
