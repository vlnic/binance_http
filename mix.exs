defmodule BinanceHttp.MixProject do
  use Mix.Project

  @source_url "https://github.com/vlnic/binance_http"
  @version "0.1.2"

  def project do
    [
      app: :binance_http,
      version: "0.1.2",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env),
      package: package(),
      description: description(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger, :crypto]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def description do
    """
      Simple HTTP Client for Binance API
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:construct, "~> 2.0"},
      {:mox, ">= 0.0.0", only: [:dev, :test]},
      {:credo, ">= 1.5.1", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  def package do
    [name: :binance_http,
     files: ["lib", "mix.exs"],
     maintainers: ["Vladimir Pavlov"],
     licenses: ["MIT"],
     links: %{"GitHub" => @source_url}]
  end

  defp docs() do
    [
      main: "readme",
      name: "Binance HTTP",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/binance-http",
      source_url: @source_url,
      extras: ["README.md", "LICENSE"]
    ]
  end
end
