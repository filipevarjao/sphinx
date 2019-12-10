defmodule SphinxRtm.MessagesTest do
  use Slack
  use Sphinx.DataCase

  import Mock

  alias SphinxRtm.Messages

  @question %{type: "message", channel: "XYZ", ts: "123.456", user: "ABC", text: "Hello"}
  @answer %{
    type: "message",
    channel: "XYZ",
    thread_ts: "123.456",
    ts: "124.456",
    user: "DEF",
    text: "World"
  }
  @user_a %{"user" => %{"name" => "user_a", "id" => "ABC"}}
  @user_b %{"user" => %{"name" => "user_b", "id" => "DEF"}}

  @question_permalink %{"permalink" => "https://fake_question_http"}
  @answer_permalink %{"permalink" => "https://fake_answer_http?thread_ts=fake_question_http"}

  test "incoming question is processed" do
    with_mocks([
      {Slack.Web.Users, [], [info: fn "ABC" -> @user_a end]},
      {Slack.Web.Chat, [], [get_permalink: fn "XYZ", "123.456" -> @question_permalink end]}
    ]) do
      assert {:ok, riddle} = Messages.process(@question)
      assert riddle.enquirer == get_user(@user_a)
      assert riddle.permalink == get_permalink(@question_permalink)
      assert riddle.title == @question.text
    end
  end

  test "incoming reply is processed" do
    with_mocks([
      {Slack.Web.Users, [],
       [
         info: fn
           "ABC" -> @user_a
           "DEF" -> @user_b
         end
       ]},
      {Slack.Web.Chat, [],
       [
         get_permalink: fn
           "XYZ", "123.456" -> @question_permalink
           "XYZ", "124.456" -> @answer_permalink
         end
       ]}
    ]) do
      assert {:ok, _} = Messages.process(@question)
      assert {:ok, riddle} = Messages.process(@answer)
      assert riddle.enquirer == get_user(@user_a)
      assert riddle.solver == get_user(@user_b)
      assert riddle.permalink_answer == get_permalink(@answer_permalink)
    end
  end

  defp get_user(user_map), do: get_in(user_map, ["user", "name"])
  defp get_permalink(permalink_map), do: Map.get(permalink_map, "permalink")
end
