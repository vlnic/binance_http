defmodule BinanceHttp.MixProject do
  use Mix.Project

  def project do
    [
      app: :binance_http,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:construct, "~> 2.0"}
    ]
  end

  def package do
    [name: :binance_http,
     files: ["lib", "mix.exs"],
     maintainers: ["Vladimir Pavlov"],
     licenses: ["MIT"],
     links: %{}]
  end
end
