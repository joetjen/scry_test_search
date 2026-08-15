defmodule Scry.Test.Search.Seed do
  @moduledoc """
  A small, realistic article set shaped after the worked example domain
  (`articles`/`title`/`category`/`published_at`/`content`) --
  deliberately including rows that miss a `SEARCH`
  match, rows outside a plausible `WHERE published_at >= ...` cutoff,
  and rows in a different `category`, so a query combining `SEARCH`
  with ordinary filters has real negative cases to exclude, not just
  positive ones to find.
  """

  @doc "The `Scry.Search.Executor.run/3` `conn` shape -- a plain `%{[String.t(), ...] => [row]}` map."
  @spec articles() :: %{[String.t()] => [map()]}
  def articles do
    %{
      ["articles"] => [
        %{
          "id" => 1,
          "title" => "Deep Learning Basics",
          "category" => "research",
          "published_at" => ~D[2025-06-01],
          "content" =>
            "Machine learning is a subset of AI, and deep learning is a subset of machine learning."
        },
        %{
          "id" => 2,
          "title" => "Gardening Tips",
          "category" => "research",
          "published_at" => ~D[2025-06-02],
          "content" => "How to grow tomatoes in your machine-tilled garden."
        },
        %{
          "id" => 3,
          "title" => "Old Machine Learning Research",
          "category" => "research",
          "published_at" => ~D[2024-01-01],
          "content" => "Machine learning research from before the cutoff."
        },
        %{
          "id" => 4,
          "title" => "Machine Learning In The News",
          "category" => "news",
          "published_at" => ~D[2025-06-03],
          "content" => "Machine learning is in the news."
        },
        %{
          "id" => 5,
          "title" => "Sourdough Bread",
          "category" => "food",
          "published_at" => ~D[2025-06-04],
          "content" => "A gentle introduction to sourdough starters."
        }
      ]
    }
  end
end
