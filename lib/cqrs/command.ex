defmodule Cqrs.Command do
  defmacro __using__(_opts) do
    quote do
      alias __MODULE__.Form
    end
  end
end
