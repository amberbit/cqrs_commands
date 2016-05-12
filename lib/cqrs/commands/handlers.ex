defmodule Cqrs.Commands.Handlers do
  def start_link(name) do
    Agent.start_link(fn -> read_handlers_from_config end, name: name)
  end

  def handlers do
    Agent.get(__MODULE__, &(&1))
  end

  def add_handler(command_name, module_and_reqs) do
    Agent.update(__MODULE__, &(Map.put(&1, command_name, module_and_reqs)))
    handlers
  end

  defp read_handlers_from_config do
    Application.get_env(:cqrs, :commands) || %{}
  end
end
