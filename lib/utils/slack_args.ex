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

  @spec history_args(map()) :: map()
  def history_args(attrs \\ %{}) do
    channel = Map.get(attrs, :channel)
    count = Map.get(attrs, :count, 100)
    inclusive = Map.get(attrs, :inclusive, 0)
    latest = Map.get(attrs, :latest, "now")
    oldest = Map.get(attrs, :oldest, 0)
    unreads = Map.get(attrs, :unreads, 0)

    optional =
      clean_fields(%{
        count: count,
        inclusive: inclusive,
        latest: latest,
        oldest: oldest,
        unreads: unreads
      })

    Map.merge(%{channel: channel}, optional)
  end

  defp clean_fields(params) do
    params
    |> Enum.reject(fn {_k, v} -> v == nil end)
    |> Enum.into(%{})
  end
end
