defmodule SphinxRtm.Messages do

  alias SphinxRtm.Messages.Parser
  alias Sphinx.Riddles
  alias Sphinx.SlackUtils
  alias Sphinx.Answers

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

        text = Parser.trim_mention(message.text)

        case SlackUtils.search(text, message.channel) do
          nil ->
            {:reply, "You asked for \"#{text}\" but I have no answer!"}

          reply ->
            {:reply,
             "You asked for \"#{text}\" but I have no answer, but I found it: \n #{reply}"}
        end

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
    question =
      %{:permalink => get_thread_permalink(message.channel, message.thread_ts)}
      |> Riddles.get()

    %{}
    |> Map.put(:solver, user(message.user))
    |> Map.put(:permalink, permalink(message.channel, message.ts))
    |> Answers.create(question)
  end

  defp user(user_id), do: SlackUtils.get_user_name(user_id)
  defp permalink(channel_id, ts), do: SlackUtils.get_permalink(channel_id, ts)

  defp get_thread_permalink(channel_id, ts) do
    permalink(channel_id, ts)
    |> String.replace(~r/[?](.)*/, "")
  end
end
