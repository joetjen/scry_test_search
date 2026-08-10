defmodule Mix.Tasks.Scry.QueryConfigTest do
  @moduledoc """
  `mix scry.query`/`mix scry.iex` themselves live in `scry_core` (a
  generic, config-driven pair -- see that package's own `Scry.Core.
  QueryTool` moduledoc) and are already fully tested there. This is
  just a smoke test that THIS package's own `config/config.exs` wires
  them correctly end to end -- `Scry.Search.parse/1` as the parser,
  `Scry.Test.Search.Adapter` bridging `Scry.Search.Executor`'s own
  `(query, conn, params)` shape to the `(query, engine, conn)` one
  `Scry.Core.QueryTool` expects, and `Scry.Test.Search.Conn.articles/0`
  as the sole named backend.
  """

  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  test "a SEARCH query runs correctly through the configured backend" do
    output =
      capture_io(fn ->
        Mix.Tasks.Scry.Query.run([
          ~s(SELECT articles WHERE content SEARCH "sourdough" { title })
        ])
      end)

    assert output =~ ~s("title" => "Sourdough Bread")
  end

  test "the sole configured backend is used implicitly, with no --backend flag needed" do
    output =
      capture_io(fn -> Mix.Tasks.Scry.Query.run([~s(SELECT articles { title })]) end)

    assert output =~ ~s("title" => "Sourdough Bread")
  end
end
