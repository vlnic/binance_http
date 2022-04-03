defmodule BinanceHttp.Api.BehaviourDef do
  @moduledoc """
  Used to define behaviour module for CcsSdk.API methods, most often it will
  be used together with Mox.

      # somewhere in ccs_sdk
      defmodule CcsSdk.API.Trusts.V3 do
        use CcsSdk.API

        defm :status,
          method: {:get, "/api/v3/trusts/internal/status"},
          params: {:primitive, {:array, UUID5}},
          params_fn: fn(servers) -> %{server_ids: servers} end

      end

      # lib/my_app/business_module.exs
      defmodule MyApp.BusinessModule do
        @trusts_v3 Application.compile_env!(:my_app, :trusts_v3_sdk)

        def status(server_ids) do
          @trusts_v3.status(server_ids)
        end
      end

      # config/config.exs
      config :my_app, :trusts_v3_sdk, CcsSdk.API.Trusts.V3

      # config/test.exs
      config :my_app, :trusts_v3_sdk, CcsSdk.API.Trusts.V3.Mock

      # test/support/mocks.ex
      Mox.defmock(CcsSdk.API.Trusts.V3.Mock, for: CcsSdk.API.Trusts.V3.Behaviour)

      # test/my_app/business_module_test.exs
      Mox.expect(CcsSdk.API.Trusts.V3.Mock, :status, fn(_params) ->
        {:ok, []}
      end)

  """

  defmacro __using__(_opts \\ []) do
    quote do
      @after_compile {BinanceHttp.API, :__after_compile__}

      Module.register_attribute __MODULE__, :methods, accumulate: true

      def __methods__, do: Module.get_attribute(__MODULE__, :methods)
    end
  end

  def define(module, name) do
    Module.put_attribute(module, :methods, name)
  end

  def apply_mox(module, name, args) do
    apply(Module.concat(module, Mock), name, args)
  end

  def define_module(env) do
    module = Module.concat(env.module)
    methods = env.module.__methods__

    contents = Enum.map(methods, &define_callbacks/1)

    Module.create(module, contents, env)
  end

  defp define_callbacks(method) do
    quote do
      @callback unquote(method)()
                :: :ok | {:ok, term} | {:error, term}

      @callback unquote(method)(params :: map | Keyword.t)
                :: :ok | {:ok, term} | {:error, term}

      @callback unquote(method)(params :: map | Keyword.t, opts :: Keyword.t)
                :: :ok | {:ok, term} | {:error, term}
    end
  end
end
