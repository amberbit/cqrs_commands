defmodule Cqrs.Command do
  defmacro __using__(_opts) do
    quote do
      alias __MODULE__.Form

      def trigger(event, payload) do
        Cqrs.Events.Server.trigger(event, payload \\ %{})
      end
    end
  end
end

