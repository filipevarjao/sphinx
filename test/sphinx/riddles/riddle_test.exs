defmodule Sphinx.Riddles.RiddleTest do
  use ExUnit.Case

  alias Sphinx.Riddles.Riddle

  @params %{
    title: "title",
    permalink: "permalink",
    permalink_answer: "answer",
    keywords: ["keyword", "key", "word"],
    upvote: 1,
    enquirer: "A_USER",
    solver: "B_USER"
  }

  describe "permalink field" do
    test "is required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :permalink))

      refute changeset.valid?
      assert changeset.errors == [permalink: {"can't be blank", [validation: :required]}]
    end

    test "is an string" do
      changeset = Riddle.changeset(%Riddle{}, @params)
      assert changeset.valid?
    end
  end

  describe "keywords field" do
    test "is not required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :keywords))
      assert changeset.valid?
    end

    test "different than array must fail" do
      params = %{@params | keywords: 123}
      changeset = Riddle.changeset(%Riddle{}, params)

      refute changeset.valid?

      assert changeset.errors == [
               keywords: {"is invalid", [type: {:array, :string}, validation: :cast]}
             ]
    end
  end

  describe "title field" do
    test "is not required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :title))
      assert changeset.valid?
    end

    test "is an string" do
      changeset = Riddle.changeset(%Riddle{}, @params)
      assert changeset.valid?
    end
  end

  describe "permalink_answer field" do
    test "is not required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :permalink_answer))
      assert changeset.valid?
    end

    test "is an string" do
      changeset = Riddle.changeset(%Riddle{}, @params)
      assert changeset.valid?
    end

    test "different than string must fail" do
      params = %{@params | permalink_answer: 123}
      changeset = Riddle.changeset(%Riddle{}, params)

      refute changeset.valid?

      assert changeset.errors == [
        permalink_answer: {"is invalid", [type: :string, validation: :cast]}
             ]
    end
  end

  describe "upvote field" do
    test "is not required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :upvote))
      assert changeset.valid?
    end

    test "is an integer" do
      changeset = Riddle.changeset(%Riddle{}, @params)
      assert changeset.valid?
    end
  end

  describe "enquirer field" do
    test "is required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :enquirer))
      refute changeset.valid?
      assert changeset.errors == [enquirer: {"can't be blank", [validation: :required]}]
    end

    test "is an string" do
      changeset = Riddle.changeset(%Riddle{}, @params)
      assert changeset.valid?
    end
  end

  describe "solver field" do
    test "is not required" do
      changeset = Riddle.changeset(%Riddle{}, Map.delete(@params, :solver))
      assert changeset.valid?
    end

    test "is an string" do
      changeset = Riddle.changeset(%Riddle{}, @params)
      assert changeset.valid?
    end
  end
end
