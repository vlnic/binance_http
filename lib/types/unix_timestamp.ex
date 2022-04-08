defmodule BinanceHttp.Types.UnixTimestamp do
  @behaviour Construct.Type

  def cast(t) do
    case DateTime.from_unix(t) do
      {:ok, _} -> {:ok, t}
      error -> error
    end
  end
end
