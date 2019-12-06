defmodule Sphinx.RiddlesTest do
  use Sphinx.DataCase

  alias Sphinx.Riddles
  alias Sphinx.Riddles.Riddle
  alias Sphinx.Repo

  describe "Riddles.create/1" do
    @params %{
      title: "title",
      permalink: "permalink",
      permalink_answer: "answer",
      keywords: ["keyword", "key", "word"],
      upvote: 1,
      enquirer: "A_USER",
      solver: "B_USER"
    }

    test "works with correct params" do
      assert [] == Repo.all(Riddle)
      assert {:ok, riddle} = Riddles.Riddles.create(@params)
      assert [riddle] == Repo.all(Riddle)
    end
  end
end
