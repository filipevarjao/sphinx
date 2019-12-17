defmodule SphinxRtm.MessagesTest do
  use Slack
  use Sphinx.Support.DataCase

  import Mock

  alias SphinxRtm.Messages
  alias Sphinx.Repo
  alias Sphinx.Riddles
  alias Sphinx.Riddles.Riddle
  alias Sphinx.Answers

  @question %{type: "message", channel: "XYZ", ts: "123.456", user: "ABC", text: "<@SPX> Hello"}
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
  @sphinx %{"user" => %{"name" => "sphinx", "id" => "SPX"}}

  @question_permalink %{"permalink" => "https://fake_question_http"}
  @question_thread_permalink %{
    "permalink" => "https://fake_question_http?thread_ts=fake_question_http"
  }
  @answer_permalink %{"permalink" => "https://fake_answer_http?thread_ts=fake_question_http"}

  @thread_riddle %{enquirer: "user_a", title: "Hello", permalink: "https://fake_question_http"}

  describe "incoming question is" do
    test "replied and save message when sphinx is mentioned" do
      with_mocks([
        {Slack.Web.Users, [],
         [
           info: fn
             "ABC" -> @user_a
             "SPX" -> @sphinx
           end
         ]},
        {Slack.Web.Chat, [], [get_permalink: fn "XYZ", "123.456" -> @question_permalink end]}
      ]) do
        assert {:reply, _text} = Messages.process(@question)

        [riddle] = Repo.all(Riddle)
        assert riddle.enquirer == get_user(@user_a)
        assert riddle.permalink == get_permalink(@question_permalink)
        assert riddle.title == trim_mention(@question.text)
      end
    end

    test "dicarded when sphinx is not mentioned" do
      question = Map.put(@question, :text, "Hello")

      with_mock(Slack.Web.Users,
        info: fn
          "ABC" -> @user_a
          "SPX" -> @sphinx
        end
      ) do
        assert :no_reply = Messages.process(question)

        [] = Repo.all(Riddle)
      end
    end

    test "dicarded when someone else than sphinx mentioned" do
      question = Map.put(@question, :text, "<@DEF> Hello")

      with_mock(Slack.Web.Users,
        info: fn
          "ABC" -> @user_a
          "DEF" -> @user_b
          "SPX" -> @sphinx
        end
      ) do
        assert :no_reply = Messages.process(question)

        [] = Repo.all(Riddle)
      end
    end

    test "capable to search if there is no answer for the question" do
      with_mocks([
        {Slack.Web.Users, [],
         [
           info: fn
             "ABC" -> @user_a
             "SPX" -> @sphinx
           end
         ]},
        {Slack.Web.Chat, [], [get_permalink: fn "XYZ", "123.456" -> @question_permalink end]}
      ]) do
        question = %{@question | text: "<@SPX> 5eb63bbbe01eeed093cb22bb8f5acdc3"}
        assert {:reply, response} = Messages.process(question)

        assert "You asked for \"5eb63bbbe01eeed093cb22bb8f5acdc3\" but I have no answer!" =~
                 response
      end
    end
  end

  describe "incoming reply is" do
    test "saved when thread is saved" do
      # Fake data of "asked question"
      Riddles.create(@thread_riddle)

      with_mocks([
        {Slack.Web.Users, [],
         [
           info: fn
             "ABC" -> @user_a
             "DEF" -> @user_b
             "SPX" -> @sphinx
           end
         ]},
        {Slack.Web.Chat, [],
         [
           get_permalink: fn
             "XYZ", "123.456" -> @question_thread_permalink
             "XYZ", "124.456" -> @answer_permalink
           end
         ]}
      ]) do
        assert :no_reply = Messages.process(@answer)

        [riddle] = Repo.all(Riddle)
        [answer] = Answers.all(riddle)
        assert riddle.enquirer == get_user(@user_a)
        assert answer.solver == get_user(@user_b)
        assert answer.permalink == get_permalink(@answer_permalink)
      end
    end

    test "not saved when thread is not saved" do
      with_mocks([
        {Slack.Web.Users, [],
         [
           info: fn
             "ABC" -> @user_a
             "DEF" -> @user_b
             "SPX" -> @sphinx
           end
         ]},
        {Slack.Web.Chat, [],
         [
           get_permalink: fn
             "XYZ", "123.456" -> @question_thread_permalink
             "XYZ", "124.456" -> @answer_permalink
           end
         ]}
      ]) do
        assert :no_reply = Messages.process(@answer)

        [] = Repo.all(Riddle)
      end
    end
  end

  defp get_user(user_map), do: get_in(user_map, ["user", "name"])
  defp get_permalink(permalink_map), do: Map.get(permalink_map, "permalink")
  defp trim_mention(text), do: String.replace(text, ~r/[<@](.)*[>]\s/, "")
end
