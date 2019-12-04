defmodule Sphinx.Riddles.RiddleTest do
  use ExUnit.Case

  alias Sphinx.Riddles.Riddle

  @params %{
    permalink: "permalink",
    keywords: ["keyword", "key", "word"]
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
end
