defmodule SphinxRtmTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  require Logger

  alias SphinxRtm

  setup_all do
    token = Application.get_env(:slack, :api_token)
    {:ok, pid} = Slack.Bot.start_link(SphinxRtm, [], token)
    {:ok, pid: pid}
  end

  describe "Invoking Sphinx" do
    test "sending message to slack channel", %{pid: pid} do
      assert Process.alive?(pid) == true

      send(pid, {:message, "External message", "CR1LTP79B"})

      assert capture_log(fn -> Process.sleep(500) end) =~
               "Sending the message to"
    end

    @tag :pending
    test "triggering events to sphinx", %{pid: pid} do
      assert Process.alive?(pid) == true

      :gen_fsm.send_event(
        pid,
        Poison.encode!(%{type: "message", channel: "CR1LTP79B", text: "test"})
      )

      assert capture_log(fn -> Process.sleep(200) end) =~
               "Processing message from"
    end
  end
end
