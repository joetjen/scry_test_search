# scry_test_search

Shared test fixtures for
[`scry_search`](https://github.com/joetjen/scry_search): one seed
dataset (`Scry.Test.Search.Seed`) — a small article set shaped after
the worked example domain — servable through
`Scry.Test.Search.Conn.articles/0`.

**Only one constructor, not a family of interchangeable backends, and
no bespoke `Conn` struct either.** Unlike
[`scry_test_core`](https://github.com/joetjen/scry_test_core)/
[`scry_test_time_series`](https://github.com/joetjen/scry_test_time_series)
(one constructor *per* interchangeable `Scry.Core.EngineBehaviour`
backend, for genuine cross-backend parity testing), `scry_search` has
exactly one executor (`Scry.Search.Executor`, implementing `Scry.Core.
EngineBehaviour` directly against a plain `%{[String.t(), ...] =>
[row]}` map — that package's own `CHANGELOG.md` has the full "`SEARCH`
needs no new storage primitive, only new execution logic" reasoning).
There's nothing to parity-test *against* yet. This package's own value
is narrower and still real: a shared, realistic fixture (reusable by
an application's own integration tests, or this kind's own future real
adapter's test suite, once one exists) plus `scry_core`'s own `mix
scry.query`/`mix scry.iex`, configured here, for ad-hoc exploration.

Source: <https://github.com/joetjen/scry_test_search>. The kind this
exercises lives in
[`scry_search`](https://github.com/joetjen/scry_search).

## Usage

```elixir
{:ok, query} =
  Scry.Search.parse(~s(SELECT articles WHERE content SEARCH "sourdough" { title }))

{:ok, cursor} = Scry.Search.Executor.run(query, Scry.Test.Search.Conn.articles())
Scry.Core.Cursor.to_list(cursor)
# [%{"title" => "Sourdough Bread"}]
```

## `mix scry.query`/`mix scry.iex`

Both tasks live in `scry_core` itself (a generic, config-driven pair —
see that package's own README/`Scry.Core.QueryTool` moduledoc). This
package's own `config/config.exs` wires them to `Scry.Search.parse/1`
and `Scry.Test.Search.Conn.articles/0` via a small `Scry.Test.Search.
Adapter` (bridging `Scry.Search.Executor`'s own `(query, conn, params)`
shape to the `(query, engine, conn)` one `Scry.Core.QueryTool` expects
— `scry_search` has no separate "engine" concept at all, so there's
nothing real for that middle argument to be):

```console
$ mix scry.query 'SELECT articles WHERE content SEARCH "sourdough" { title }'
$ mix scry.iex
```

No `--backend` flag needed — this package registers exactly one named
backend, used implicitly.

## Installation

```elixir
def deps do
  [
    {:scry_test_search, "~> 0.1.0", only: :test}
  ]
end
```

## Documentation

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc):

- Released versions are published to [HexDocs](https://hexdocs.pm) once the
  package ships, at <https://hexdocs.pm/scry_test_search>.
- Latest `main` is built and deployed automatically by
  [`.github/workflows/docs.yml`](.github/workflows/docs.yml) to
  [GitHub Pages](https://joetjen.github.io/scry_test_search/) on every push to `main`.
