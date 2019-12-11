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
  def process(message) do
    case Map.has_key?(message, :thread_ts) do
      true ->
        process_reply(message)
        :no_reply

      false ->
        # TODO: check if @sphinx is invoked
        case Parser.mention_sphinx?(message.text) do
          true ->
            process_question(message)
            {:reply, "Are you asking for me?"}

          false ->
            :no_reply
        end
    end
  end

  @spec process_question(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  defp process_question(message) do
    %{}
    |> Map.put(:enquirer, user(message.user))
    |> Map.put(:title, message.text)
    |> Map.put(:permalink, permalink(message.channel, message.ts))
    |> Riddles.create()
  end

  @spec process_reply(map()) :: {:ok, Riddles.Riddle.t()} | {:error, Ecto.Changeset.t()}
  defp process_reply(message) do
    %{}
    |> Map.put(:solver, user(message.user))
    |> Map.put(:permalink_answer, permalink(message.channel, message.ts))
    |> Map.put(:permalink, permalink(message.channel, message.thread_ts))
    |> Riddles.update()
  end

  defp user(user_id), do: SlackUtils.get_user_name(user_id)
  defp permalink(channel_id, ts), do: SlackUtils.get_permalink(channel_id, ts)
end
