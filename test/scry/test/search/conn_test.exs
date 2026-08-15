defmodule Scry.Test.Search.ConnTest do
  @moduledoc """
  `Scry.Test.Search.Conn.articles/0` -- confirms it returns a real,
  working `conn` (prefilled with `Scry.Test.Search.Seed`'s own
  dataset), actually executing `SEARCH`/`relevance()` correctly
  through `Scry.Search.Executor.run/3`.
  """

  use ExUnit.Case, async: true

  alias Scry.Core.Cursor
  alias Scry.Search.Executor
  alias Scry.Test.Search.Conn

  defp run!(source) do
    {:ok, query} = Scry.Search.parse(source)
    {:ok, cursor} = Executor.run(query, Conn.articles())
    Cursor.to_list(cursor)
  end

  test "an ordinary top-level query works with no SEARCH at all" do
    titles = "SELECT articles { title }" |> run!() |> Enum.map(& &1["title"]) |> Enum.sort()

    assert titles == [
             "Deep Learning Basics",
             "Gardening Tips",
             "Machine Learning In The News",
             "Old Machine Learning Research",
             "Sourdough Bread"
           ]
  end

  test "the worked example runs correctly against this fixture" do
    rows =
      run!("""
      SELECT articles
          WHERE published_at >= 2025-01-01 AND category = "research" AND content SEARCH "machine learning"
          ORDER BY relevance() DESC LIMIT 5
      {
          title,
          score: relevance()
      }
      """)

    # "Old Machine Learning Research" excluded (published before the
    # cutoff); "Machine Learning In The News" excluded (wrong
    # category); "Sourdough Bread" excluded (no token overlap at all).
    assert rows == [
             %{"title" => "Deep Learning Basics", "score" => 2},
             %{"title" => "Gardening Tips", "score" => 1}
           ]
  end

  test "calling articles/0 twice returns independent, identically-seeded connections" do
    assert Conn.articles() == Conn.articles()
  end
end
