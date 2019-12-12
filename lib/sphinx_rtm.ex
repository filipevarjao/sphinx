defmodule SphinxRtm do
  use Slack

  require Logger

  alias SphinxRtm.Messages
  alias Sphinx.SlackUtils

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    {:ok, state}
  end

  # Ignore event with subtype (delete, change...)
  def handle_event(%{type: "message", subtype: _some_event}, _slack, state) do
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    user = SlackUtils.get_user_name(message.user)
    Logger.info("Processing message from #{user}")
    case Messages.process(message) do
      {:reply, text} ->
        send_message(text, message.channel, slack)
        {:ok, state}

      :no_reply ->
        {:ok, state}
    end
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info("Sending the message to #{channel}")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
