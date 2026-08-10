import Config

# Wires this package's own single Scry.Test.Search.Conn.articles/0
# fixture into scry_core's generic mix scry.query/mix scry.iex -- see
# Scry.Core.QueryTool's own moduledoc for the full config shape.
# parser: points at Scry.Search.parse/1, since this package exercises
# the search kind, not core's own degenerate one. executor: is Scry.
# Test.Search.Adapter, not Scry.Search.Executor directly -- the adapter
# bridges QueryTool's own (query, engine, conn) calling convention to
# Scry.Search.Executor's (query, conn, params) shape (that module's own
# moduledoc has the full "why" -- scry_search has no separate "engine"
# concept at all).
config :scry_core, :query_tool,
  parser: Scry.Search,
  executor: {Scry.Test.Search.Adapter, :run},
  backends: %{
    "search" => {Scry.Test.Search.Adapter, :conn}
  }
