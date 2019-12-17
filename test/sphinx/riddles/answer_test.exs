defmodule Sphinx.Riddles.AnswerTest do
  use ExUnit.Case

  alias Sphinx.Answers.Answer

  @params %{
    permalink: "permalink",
    upvote: 1,
    solver: "A_USER"
  }

  describe "permalink field" do
    test "is required" do
      changeset = Answer.changeset(%Answer{}, Map.delete(@params, :permalink))
      refute changeset.valid?
      assert changeset.errors == [permalink: {"can't be blank", [validation: :required]}]
    end

    test "is an string" do
      changeset = Answer.changeset(%Answer{}, @params)
      assert changeset.valid?
    end
  end

  describe "upvote field" do
    test "is not required" do
      changeset = Answer.changeset(%Answer{}, Map.delete(@params, :upvote))
      assert changeset.valid?
    end

    test "is an integer" do
      changeset = Answer.changeset(%Answer{}, @params)
      assert changeset.valid?
    end
  end

  describe "solver field" do
    test "is  required" do
      changeset = Answer.changeset(%Answer{}, Map.delete(@params, :solver))
      refute changeset.valid?
      assert changeset.errors == [solver: {"can't be blank", [validation: :required]}]
    end

    test "is an string" do
      changeset = Answer.changeset(%Answer{}, @params)
      assert changeset.valid?
    end
  end
end
