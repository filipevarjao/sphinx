defmodule Sphinx.Messages do
  use Slack
  alias Slack.Web.Chat
  alias Sphinx.Riddles

  ## TODO: check if message is a question
  ## if yes then get the keywords and search for old questions
  ## else check if it is related to/ answering the recent question.
  ## If yes, save the answer
  ## Else discard (something like that?)
  def process({:question, message}) do
    user = get_user_name(message.user)
    title = message.text
    permalink = get_permalink(message.channel, message.ts)
    save_question(%{permalink: permalink, title: title, enquirer: user})
  end

  def process({:reply, message}) do
    user = get_user_name(message.user)
    reply_permalink = get_permalink(message.channel, message.ts)
    thread_permalink = get_permalink(message.channel, message.thread_ts)

    save_reply(
      thread_permalink,
      %{permalink_answer: reply_permalink, solver: user}
    )
  end

  defp get_permalink(channel, ts) do
    Chat.get_permalink(channel, ts)
    |> Map.get("permalink")
  end

  defp get_user_name(user) do
    user
    |> Slack.Web.Users.info()
    |> get_in(["user", "name"])
  end

  defp save_question(question_params) do
    Riddles.create(question_params)
  end

  defp save_reply(thread_permalink, answer_params) do
    id =
      thread_permalink
      |> String.replace(~r/[?](.)*/, "")
      |> Riddles.get_by_permalink()
      |> Map.get(:id)

    answer_params
    |> Map.put(:id, id)
    |> Riddles.update()
  end
end
