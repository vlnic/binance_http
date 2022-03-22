defmodule BinanceHttp.Behaviours.Http do
  @callback request(method :: binary, url :: binary, body :: term,
              headers :: map, opts :: list)
  :: {:ok, status :: non_neg_integer, headers :: list | map, body :: nil | binary}
  | {:error, term}

end
