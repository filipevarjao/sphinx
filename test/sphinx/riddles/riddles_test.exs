defmodule Sphinx.RiddlesTest do
  use Sphinx.Support.DataCase

  alias Sphinx.Riddles
  alias Sphinx.Riddles.Riddle
  alias Sphinx.Repo

  @params %{
    title: "title",
    permalink: "permalink",
    keywords: ["keyword", "key", "word"],
    enquirer: "A_USER"
  }

  describe "Riddles.create/1" do
    test "works with correct params" do
      assert [] == Repo.all(Riddle)
      assert {:ok, riddle} = Riddles.create(@params)
      assert [riddle] == Repo.all(Riddle)
      assert riddle.title == @params.title
      assert riddle.permalink == @params.permalink
      assert riddle.keywords == @params.keywords
      assert riddle.enquirer == @params.enquirer
    end

    test "fails with wrong params" do
      assert {:error, changeset} = Riddles.create(Map.delete(@params, :permalink))
      refute changeset.valid?
    end
  end

  describe "Riddles.list/1" do
    test "lists all" do
      {:ok, riddle1} = Riddles.create(@params)
      {:ok, riddle2} = Riddles.create(%{@params | permalink: "permalink2"})

      result = Riddles.list(%{})

      assert Enum.member?(result.entries, riddle1)
      assert Enum.member?(result.entries, riddle2)
    end

    test "filtering by fields" do
      params = %{
        title: "title_II",
        permalink: "permalink_II",
        keywords: ["other", "another", "word"],
        enquirer: "A_USER",
      }

      {:ok, riddle1} = Riddles.create(@params)
      {:ok, riddle2} = Riddles.create(params)

      result = Riddles.list(%{enquirer: @params.enquirer})
      assert length(result.entries) == 2
      assert Enum.member?(result.entries, riddle1)
      assert Enum.member?(result.entries, riddle2)

      result = Riddles.list(%{title: params.title})
      assert length(result.entries) == 1
      assert Enum.member?(result.entries, riddle2)

      result = Riddles.list(%{permalink: @params.permalink})
      assert length(result.entries) == 1
      assert Enum.member?(result.entries, riddle1)
    end
  end

  describe "Riddles.get/1" do
    test "returns the riddle if exists" do
      {:ok, riddle} = Riddles.create(@params)
      assert riddle
      id = riddle.id
      assert riddle == Riddles.get(%{id: id, title: @params.title})
    end

    test "returns nil if riddle not exist" do
      assert [] == Repo.all(Riddle)

      refute Riddles.get(%{id: 1001, title: ""})
    end
  end

  describe "Riddles.delete/1" do
    test "returns the deleted riddle if exists" do
      {:ok, riddle} = Riddles.create(@params)
      assert riddle
      assert [riddle] == Repo.all(Riddle)
      assert {:ok, deleted_riidle} = Riddles.delete(%{id: riddle.id, title: @params.title})
      assert riddle.id == deleted_riidle.id
      assert [] == Repo.all(Riddle)
    end

    test "returns error if the riddle does not exist" do
      assert [] == Repo.all(Riddle)
      assert {:error, :not_found} = Riddles.delete(%{id: 1001, title: ""})
    end
  end

  describe "Riddles.update/1" do
    test "updates a riddle if is ok" do
      {:ok, riddle} = Riddles.create(@params)
      assert riddle

      params =
        %{@params | title: "title_II"}
        |> Map.put(:id, riddle.id)

      assert {:ok, updated} = Riddles.update(params)
      assert riddle.id == updated.id
      assert updated.title == "title_II"
    end

    test "updates a riddle by permalink" do
      {:ok, riddle} = Riddles.create(@params)
      assert riddle

      params = %{@params | title: "title_II"}

      assert {:ok, updated} = Riddles.update(params)
      assert riddle.id == updated.id
      assert updated.title == "title_II"
    end

    test "does not update with wrong params" do
      {:ok, riddle} = Riddles.create(@params)
      assert riddle

      params =
        %{@params | keywords: 123}
        |> Map.put(:id, riddle.id)

      assert {:error, changeset} = Riddles.update(params)

      assert changeset.errors == [
               keywords: {"is invalid", [type: {:array, :string}, validation: :cast]}
             ]
    end

    test "does not update if do not exist" do
      assert [] == Repo.all(Riddle)
      params = Map.put(@params, :id, 101)
      assert {:error, :not_found} = Riddles.update(params)
    end
  end
end
