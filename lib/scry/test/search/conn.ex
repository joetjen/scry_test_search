defmodule Scry.Test.Search.Conn do
  @moduledoc """
  One constructor, `articles/0`, returning a ready `conn` prefilled
  with `Scry.Test.Search.Seed`'s own data -- straight into `Scry.
  Search.Executor.run/3`'s own second argument.

  Unlike `Scry.Test.Core.Conn`/`Scry.Test.TimeSeries.Conn` (one
  constructor *per* interchangeable `Scry.Core.EngineBehaviour`
  backend), there's only ever one constructor here, and no bespoke
  struct either: `scry_search` has exactly one executor (`Scry.Search.
  Executor`, implementing `EngineBehaviour` directly against a plain
  `%{[String.t(), ...] => [row]}` map -- confirmed in that package's
  own `CHANGELOG.md`: `SEARCH` needs no new storage primitive, only new
  execution logic), not a family of interchangeable pushdown engines to
  parity-test against. This package's own value is a shared, realistic
  fixture -- reusable by anything depending on `scry_search` (an
  application's own integration tests, this kind's own future real
  adapter's own test suite, once one exists) -- and `config/config.exs`,
  wiring `scry_core`'s own generic `mix scry.query`/`mix scry.iex` to
  use it for ad-hoc exploration.
  """

  @doc "`Scry.Test.Search.Seed.articles/0`'s own dataset, unwrapped -- already the exact conn shape `Scry.Search.Executor.run/3` expects."
  @spec articles() :: %{[String.t()] => [map()]}
  def articles, do: Scry.Test.Search.Seed.articles()
end
