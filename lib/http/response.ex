defmodule BinanceHttp.Http.Response do

  def prepare_response(body, headers) do
    headers
    |> get_content_type()
    |> prepare_body(body)
  end

  defp get_content_type(headers) do
    result =
      Enum.find(headers, fn({k, _v}) ->
        k == "Content-Type"
      end)

    case result do
      {"Content-Type", value} ->
        value

      nil->
        :skip
    end
  end

  defp prepare_body(:skip, body), do: body
  defp prepare_body(type, body) do
    cond do
      String.contains?(type, "application/json") ->
        prepare_json(body)

      true ->
        body
    end
  end

  defp prepare_json(content) do
    case Jason.decode(content) do
      {:ok, result} ->
        result

      {:error, _reason} ->
       content
    end
  end
end
