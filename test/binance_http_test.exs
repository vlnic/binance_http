defmodule BinanceHttpTest do
  use ExUnit.Case
  doctest BinanceHttp

  test "greets the world" do
    assert BinanceHttp.hello() == :world
  end
end
