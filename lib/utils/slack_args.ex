defmodule Sphinx.SlackArgs do
  @spec search_args(map()) :: map()
  def search_args(attrs \\ %{}) do
    query = Map.get(attrs, :query)
    channel = Map.get(attrs, :channel)
    count = Map.get(attrs, :count, 20)
    highlight = Map.get(attrs, :highlight)
    page = Map.get(attrs, :page, 1)
    sort = Map.get(attrs, :sort, "score")
    sort_dir = Map.get(attrs, :sort_dir, "desc")
    pretty = Map.get(attrs, :pretty, 1)

    optional =
      clean_fields(%{
        count: count,
        highlight: highlight,
        page: page,
        sort: sort,
        sort_dir: sort_dir,
        pretty: pretty
      })

    Map.merge(%{channel: channel, query: query}, optional)
  end

  defp clean_fields(params) do
    params
    |> Enum.reject(fn {_k, v} -> v == nil end)
    |> Enum.into(%{})
  end
end
