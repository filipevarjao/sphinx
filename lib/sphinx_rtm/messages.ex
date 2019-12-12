defmodule SphinxRtm.Messages do
  alias Sphinx.SlackUtils
  alias Sphinx.Riddles
  alias SphinxRtm.Messages.Parser

  @user_token Application.get_env(:slack, :user_token)
  @slack_url "https://slack.com/api/"
  @channel "CR1LTP79B"

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
        case Parser.mention_sphinx?(message.text) do
          true ->
            message
            |> Map.put(:text, Parser.trim_mention(message.text))
            |> process_question()

            question = Parser.trim_mention(message.text)
            url =
              build_url("search.messages", %{
                query: question,
                channel: @channel,
                pretty: 1
              })

            {:ok, _resp} =
              url
              |> HTTPoison.get()

            # An ugly way to construct the reply but it will be changed in the future :)
            {:reply,
             "You asked for \"#{question}\" but I have no answer!"}

          false ->
            :no_reply
        end
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
