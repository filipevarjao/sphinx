defmodule SphinxRtm.Messages.ParserTest do
  alias SphinxRtm.Messages.Parser
  use ExUnit.Case

  import Mock

  @user %{"user" => %{"name" => "user_a", "id" => "ABC"}}
  @sphinx %{"user" => %{"name" => "sphinx", "id" => "SPX"}}

  describe "parser checks if sphinx-bot is invoked and returns" do
    test "true only when message starts with @sphinx" do
      message1 = "<@SPX> Hello"
      message2 = "Hello <@SPX>"

      with_mock(Slack.Web.Users, info: fn "SPX" -> @sphinx end) do
        assert Parser.mention_sphinx?(message1)
        refute Parser.mention_sphinx?(message2)
      end
    end

    test "false when someone else is mentioned" do
      message1 = "<@ABC> Hello"
      message2 = "Hello <@ABC>"

      with_mock(Slack.Web.Users, info: fn "ABC" -> @user end) do
        refute Parser.mention_sphinx?(message1)
        refute Parser.mention_sphinx?(message2)
      end
    end

    test "false when no one is mentioned in the message" do
      message = "Hello"
      refute Parser.mention_sphinx?(message)
    end
  end

  test "parser trim message if user is mentioned first in a message" do
    message1 = "<@SPX> Hello"
    message2 = "Hello"
    message3 = "Hello <@SPX>"

    assert "Hello" = Parser.trim_mention(message1)
    assert "Hello" = Parser.trim_mention(message2)
    assert "Hello <@SPX>" = Parser.trim_mention(message3)
  end
end
