defmodule Sphinx.SlackUtils do
  use Slack
  alias Slack.Web.Chat
  alias Slack.Web.Users

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
end
