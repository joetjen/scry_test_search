# Changelog

## [Unreleased]

### Added

- Initial project scaffold: `mix.exs` (app `:scry_test_search`, `{:scry_core, path: "../scry_core"}` + `{:scry_search, path: "../scry_search"}`, both real dependencies -- this package parses query text through `Scry.Search.parse/1` and drives `Scry.Search.Executor.run/3` directly), `.credo.exs`/`.formatter.exs`/`.tool-versions`, `AGENTS.md`/`CLAUDE.md`.
- `Scry.Test.Search.Seed.articles/0` -- a small article set shaped after the worked example domain (`title`/`category`/`published_at`/`content`), deliberately including rows that miss a `SEARCH` match, fall outside a plausible date cutoff, or sit in a different `category`, so a query combining `SEARCH` with ordinary filters has real negative cases to exclude.
- `Scry.Test.Search.Conn.articles/0` -- the sole constructor, returning `Seed.articles/0`'s own dataset unwrapped (already the exact plain `%{[String.t(), ...] => [row]}` map `Scry.Search.Executor.run/3` expects -- no bespoke `Conn` struct exists here, matching `scry_search` itself).
- `Scry.Test.Search.Adapter` -- bridges `Scry.Core.QueryTool`'s own `(query, engine, conn)` calling convention to `Scry.Search.Executor.run/3`'s own `(query, conn, params)` shape, the same pattern `scry_test_document`/`scry_test_graph` already established.
- `config/config.exs` wires `scry_core`'s own generic `mix scry.query`/`mix scry.iex` to `Scry.Search.parse/1` and this package's own sole backend.
- `test/scry/test/search/conn_test.exs` -- confirms `articles/0` returns a real, working conn, running the worked example against it for real; `test/mix/tasks/scry.query_test.exs` -- a smoke test that the configured Mix tasks work end to end.
