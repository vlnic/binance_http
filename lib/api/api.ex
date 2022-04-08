defmodule BinanceHttp.Api do
  alias BinanceHttp.Api.Endpoint
  alias BinanceHttp.Http.{Request, Response, Client}

  defmacro __using__(_opts \\ []) do
    quote do
      use BinanceHttp.Api.BehaviourDef

      import BinanceHttp.Api
    end
  end

  defmacro action(name, opts) do
    {endpoint, opts} = Keyword.pop(opts, :endpoint)
    {params, opts} = Keyword.pop(opts, :params)
    {params_fn, opts} = Keyword.pop(opts, :params_fn)

    {method, path} = check_endpoint!(endpoint)
    params_ast_fun = params_ast(params)

    maybe_params_fn = params_process_ast(params_fn)

    execute_ast = fn(method, path) ->
      quote do
        BinanceHttp.Api.execute(unquote(method), unquote(path), params_transformed, auth_type, opts)
      end
    end

    ast = quote do
      BinanceHttp.Api.BehaviourDef.define(__MODULE__, unquote(name))

      def unquote(name)(), do: unquote(name)(%{})
      def unquote(name)(params), do: unquote(name)(params, [])
      def unquote(name)(params, opts) do
        with {:ok, params} <- unquote(params_ast_fun) do
          opts = Keyword.merge(unquote(opts), opts)
          auth_type = Keyword.get(opts, :auth_type, :none)
          params_transformed = unquote(maybe_params_fn)
          unquote(execute_ast.(method, path))
        else
          :error -> {:error, {:primitive_type_error, params}}
          {:error, reason} -> {:error, reason}
        end
      end
    end

    if Keyword.get(opts, :dbg) do
      IO.puts(Macro.to_string(ast))
    end

    ast
  end

  def execute(method, path, params, auth_type, opts) do
    query =
      Keyword.get(opts, :query, %{})
      |> maybe_merge_query_params(params, method)
      |> filter_params()

    url = Endpoint.build(path, query, auth_type)
    body =
      params
      |> filter_params()
      |> Request.build_body(opts)
    headers = Request.build_headers([], auth_type)

    case Client.request(method, url, body, headers, []) do
      {:ok, body, headers} ->
        {:ok, Response.prepare_response(body, headers)}

      error ->
        error
    end
  end

  def __after_compile__(env, _bytecode) do
    BinanceHttp.Api.BehaviourDef.define_module(env)
  end

  defp check_endpoint!({_method, _path} = endpoint), do: endpoint
  defp check_endpoint!(invalid), do: raise "method accept {http_method, path} provided: #{inspect(invalid)}"

  defp params_ast({:primitive, type}), do: primitive_type_ast(type)
  defp params_ast({:%{}, _, _} = type), do: make_raw_types_ast(type)
  defp params_ast(type) when is_list(type), do: make_raw_types_ast(type)
  defp params_ast({:__aliases__, _, _} = type), do: make_module_ast(type)
  defp params_ast(nil), do: quote(do: {:ok, params})

  defp params_process_ast(nil), do: quote(do: params)
  defp params_process_ast(:empty), do: quote(do: %{})
  defp params_process_ast(fun), do: quote(do: unquote(fun).(params))

  defp primitive_type_ast(type) do
    quote do: Construct.Type.cast(unquote(type), params)
  end

  defp make_raw_types_ast(types) do
    quote do: Construct.Cast.make(unquote(types), params)
  end

  defp make_module_ast(type) do
    quote do: unquote(type).make(params, make_map: true)
  end

  defp maybe_merge_query_params(query, params, method) when method in [:get] do
    Map.merge(query, params)
  end
  defp maybe_merge_query_params(query, _, _), do: query

  defp filter_params(params) when is_struct(params) do
    Map.from_struct(params) |> filter_params()
  end
  defp filter_params(params) do
    for {_k,v} = p <- params, v != nil, into: %{}, do: p
  end
end
