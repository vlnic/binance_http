defmodule BinanceHttp.Types.AccountType do
  @types ~w(SPOT MARGIN FUTURES)

  def cast(t) when t in @types, do: {:ok, t}
  def cast(_), do: :error
end
