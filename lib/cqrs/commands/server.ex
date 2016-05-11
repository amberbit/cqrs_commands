defmodule Cqrs.Commands.Server do
  use GenServer

  # GenServer API
  def start_link(name) do
    GenServer.start_link(__MODULE__, %{}, [name: name])
  end

  # Public API

  def add_command(command_name, module, environment_requirements \\ []) do
    GenServer.call(__MODULE__, {:add_command, command_name, module, environment_requirements})
  end

  def command(command_name, command_arguments \\ %{}, command_environment \\ %{}) do
    GenServer.call(__MODULE__, {:command, command_name, command_arguments, command_environment})
  end

  # Private API

  def handle_call({:add_command, command_name, module, reqs}, _from, handlers) do
    handlers = Map.put handlers, command_name, {module, reqs}
    {:reply, handlers, handlers}
  end

  def handle_call({:command, command_name, command_arguments, command_environment}, _from, handlers) do
    result = case handlers[command_name] do
      nil -> {:error, :unknown_command}
      { module, reqs } -> if requirements_met?(command_environment, reqs) do
        module.execute(command_arguments, command_environment)
      else
        {:error, :requirements_not_met}
      end
    end

    {:reply, result, handlers}
  end

  defp requirements_met?(env, []) do
    true
  end

  defp requirements_met?(env, reqs) do
    reqs
    |> Enum.all?(&(env[&1]))
  end
end

