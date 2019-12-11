defmodule SphinxRtm.Messages.ParserTest do
  alias SphinxRtm.Messages.Parser
  use ExUnit.Case

  import Mock

  @user%{"user" => %{"name" => "user_a", "id" => "ABC"}}
  @sphinx %{"user" => %{"name" => "sphinx", "id" => "SPX"}}

  describe "parser returns" do
    test "true when message starts with @sphinx" do
      message = "<@SPX> Hello"
      with_mock(Slack.Web.Users, [info: fn "SPX" -> @sphinx end]) do
        assert Parser.mention_sphinx?(message)
      end
    end

    test "false when someone else is mentioned" do
      message = "<@ABC> Hello"
      with_mock(Slack.Web.Users, [info: fn "ABC" -> @user end]) do
        refute Parser.mention_sphinx?(message)
      end
    end

    test "false when no one is mentioned in the message" do
      message = "Hello"
      refute Parser.mention_sphinx?(message)
    end
  end
end
