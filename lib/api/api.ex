defmodule BinanceHttp.Api do
  alias BinanceHttp.Api.Endpoint

  defmacro __using__(opts \\ []) do
    namespace = Keyword.get(opts, :namespace, "")

    quote do
      @namespace unquote(namespace)

      import BinanceHttp.Api
    end
  end

  defmacro request(name, opts) do
    {endpoint, opts} = Keyword.pop(opts, :endpoint)
    {params, opts} = Keyword.pop(opts, :params)
    {query, opts} = Keyword.pop(opts, :query, %{})
    {params_fn, opts} = Keyword.pop(opts, :params_fn)
    {auth_type, opts} = Keyword.pop(opts, :auth_type, :none)

    {method, path} = check_endpoint!(endpoint)
    params_ast_fun = params_ast(params)

    execute_ast = fn(name, method) ->
      quote do
        BinanceHttp.Api.execute(unquote(method), path, params_transformed, opts)
      end
    end

    ast = quote do
      def unquote(name)(), do: unquote(name)(%{})
      def unquote(name)(params), do: unquote(name)(params, [])
      def unquote(name)(params, opts) do
        with {:ok, params} <- unquote(params_ast_fun) do
          path = unquote(Endpoint.build(path, query, {auth_type, params}))
          opts = Keyword.merge(unquote(opts), opts)

          params_transformed = unquote(maybe_params_fn)
          unquote(execute_ast.(name, method))
        else
          :error -> {:error, {:primitive_type_error, params}}
          {:error, reason} -> {:error, reason}
        end
      end
    end

    ast
  end

  def execute(method, path, params, opts) do

  end


  defp check_endpoint!({method, path} = endpoint), do: endpoint
  defp check_endpoint!(invalid), do: raise "method accept {http_method, path, maybe_query_params} provided: #{inspect(invalid)}"

  defp params_ast({:primitive, type}), do: primitive_type_ast(type)
  defp params_ast({:%{}, _, _} = type), do: make_raw_types_ast(type)
  defp params_ast(type) when is_list(type), do: make_raw_types_ast(type)
  defp params_ast({:__aliases__, _, _} = type), do: make_module_ast(type)
  defp params_ast(nil), do: quote(do: {:ok, params})

  defp primitive_type_ast(type) do
    quote do: Construct.Type.cast(unquote(type), params)
  end

  defp make_raw_types_ast(types) do
    quote do: Construct.Cast.make(unquote(types), params)
  end

  defp make_module_ast(type) do
    quote do: unquote(type).make(params, make_map: true)
  end
end
