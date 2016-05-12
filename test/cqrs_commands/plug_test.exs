defmodule Cqrs.Commands.PlugTest do
  use ExUnit.Case
  use Plug.Test

  defp call(conn, opts) do
    Cqrs.Commands.Plug.call(conn, opts)
  end
end
