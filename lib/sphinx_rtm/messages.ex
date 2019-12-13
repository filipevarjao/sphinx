defmodule SphinxRtm.Messages do
  alias Sphinx.SlackUtils
  alias Sphinx.Riddles
  alias SphinxRtm.Messages.Parser

  ## TODO: check if message is a question
  ## if yes then get the keywords and search for old questions
  ## else check if it is related to/ answering the recent question.
  ## If yes, save the answer
  ## Else discard (something like that?)
  @spec process(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  def process(message = %{thread_ts: _ts}) do
    save_reply(message)
    :no_reply
  end

  def process(message) do
    case Parser.mention_sphinx?(message.text) do
      true ->
        message
        |> Map.put(:text, Parser.trim_mention(message.text))
        |> save_question()

        {:reply, "You asked for \"#{Parser.trim_mention(message.text)}\" but I have no answer!"}

      false ->
        :no_reply
    end
  end

  @spec save_question(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  defp save_question(message) do
    %{}
    |> Map.put(:enquirer, user(message.user))
    |> Map.put(:title, message.text)
    |> Map.put(:permalink, permalink(message.channel, message.ts))
    |> Riddles.create()
  end

  @spec save_reply(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  defp save_reply(message) do
    %{}
    |> Map.put(:solver, user(message.user))
    |> Map.put(:permalink_answer, permalink(message.channel, message.ts))
    |> Map.put(:permalink, get_thread_permalink(message.channel, message.thread_ts))
    |> Riddles.update()
  end

  defp user(user_id), do: SlackUtils.get_user_name(user_id)
  defp permalink(channel_id, ts), do: SlackUtils.get_permalink(channel_id, ts)

  defp get_thread_permalink(channel_id, ts) do
    permalink(channel_id, ts)
    |> String.replace(~r/[?](.)*/, "")
  end
end
