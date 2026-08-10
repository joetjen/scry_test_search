defmodule Scry.Test.Search.Adapter do
  @moduledoc """
  Bridges `scry_core`'s own `Scry.Core.QueryTool` config contract
  (`backends:` returning `{engine_module, conn}`; `executor:` called as
  `(query, engine, conn)`) to `Scry.Search.Executor.run/3`'s own
  `(query, conn, params)` shape -- `scry_search` has no separate
  "engine module" concept at all (`Scry.Search.Executor` *is* the
  `Scry.Core.EngineBehaviour` implementation, called directly, not
  dispatched to through a second module), so there's nothing for a
  real `engine` argument to be.

  `config/config.exs` registers `conn/0` as the named backend and this
  module as `executor:` -- `run/3` below just discards the placeholder
  "engine" position `Scry.Core.QueryTool` always passes and forwards to
  the real thing.
  """

  @doc """
  The `{engine, conn}` shape `Scry.Core.QueryTool.resolve_backend/1`
  expects -- `__MODULE__` is a placeholder here, never actually
  dispatched to as an engine.
  """
  @spec conn() :: {module(), %{[String.t()] => [map()]}}
  def conn, do: {__MODULE__, Scry.Test.Search.Conn.articles()}

  @doc false
  @spec run(term(), module(), %{[String.t()] => [map()]}) ::
          {:ok, Scry.Core.Cursor.t()} | {:error, term()}
  def run(query, _placeholder_engine, conn), do: Scry.Search.Executor.run(query, conn)
end
