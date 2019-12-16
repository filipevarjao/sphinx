defmodule Sphinx.SlackUtils do
  use Slack
  alias Slack.Web.Chat
  alias Slack.Web.Users
  alias Sphinx.SlackArgs

  @user_token Application.get_env(:slack, :user_token)
  @slack_url Application.get_env(:slack, :slack_url)

  @spec get_permalink(String.t(), String.t()) :: String.t()
  def get_permalink(channel_id, ts) do
    Chat.get_permalink(channel_id, ts)
    |> Map.get("permalink")
  end

  @spec get_user_name(String.t()) :: String.t()
  def get_user_name(user) do
    user
    |> Users.info()
    |> get_in(["user", "name"])
  end

  @spec search(String.t(), String.t()) :: map() | nil
  def search(text, channel) do
    params = SlackArgs.search_args(%{query: text, channel: channel})
    url = build_url("search.messages", params)
    {:ok, response} = HTTPoison.get(url)
    {:ok, %{"messages" => %{"matches" => list_of_matches}}} = Poison.decode(response.body)

    case list_of_matches do
      [] -> nil
      _ -> build_response(list_of_matches, text, channel)
    end
  end

  defp build_response(matches, text, channel) do
    blocks = Enum.filter(matches, &match?(%{"channel" => %{"id" => channel}, "text" => text}, &1))
    build_text("", 1, blocks)
  end

  defp build_text(response, _, []), do: response

  defp build_text(response, count, [block | blocks]) do
    conc = Integer.to_string(count) <> " ~> #{block["permalink"]} \n "
    build_text(response <> conc, count + 1, blocks)
  end

  defp build_url(path, params) do
    url = "#{@slack_url}#{path}?token=#{@user_token}"

    optional =
      for {k, v} <- params do
        "" <> "&#{k}=#{v}"
      end

    Enum.join([url] ++ optional, "")
    |> URI.encode()
  end
end
