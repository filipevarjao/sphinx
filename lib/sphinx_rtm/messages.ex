defmodule SphinxRtm.Messages do
  use Slack
  alias Slack.Web.Chat
  alias Slack.Web.Users
  alias Sphinx.Riddles

  ## TODO: check if message is a question
  ## if yes then get the keywords and search for old questions
  ## else check if it is related to/ answering the recent question.
  ## If yes, save the answer
  ## Else discard (something like that?)
  @spec process(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  def process(message) do
    case Map.has_key?(message, :thread_ts) do
      true ->
        process_reply(message)
      false ->
        #TODO: check if @sphinx is invoked
        process_question(message)
    end
  end

  @spec process_question(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  defp process_question(message) do
    %{}
    |> Map.put(:enquirer, get_user_name(message.user))
    |> Map.put(:title, message.text)
    |> Map.put(:permalink, get_permalink(message.channel, message.ts))
    |> Riddles.create()
  end

  @spec process_reply(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  defp process_reply(message) do

    id =
      get_permalink(message.channel, message.thread_ts)
      |> get_riddle_id()

    %{}
    |> Map.put(:solver, get_user_name(message.user))
    |> Map.put(:permalink_answer, get_permalink(message.channel, message.ts))
    |> Map.put(:id, id)
    |> Riddles.update()
  end

  @spec get_permalink(String.t(), String.t()) :: String.t()
  defp get_permalink(channel, ts) do
    Chat.get_permalink(channel, ts)
    |> Map.get("permalink")
  end

  @spec get_user_name(String.t()) :: String.t()
  defp get_user_name(user) do
    user
    |> Users.info()
    |> get_in(["user", "name"])
  end

  @spec get_riddle_id(String.t()) :: integer()
  defp get_riddle_id(permalink) do
    permalink
    |> String.replace(~r/[?](.)*/, "")
    |> Riddles.get_by_permalink()
    |> Map.get(:id)
  end
end
