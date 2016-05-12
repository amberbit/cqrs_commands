defmodule Cqrs.Commands.Server do
  use GenServer
  alias Cqrs.Commands.Handlers

  # GenServer API
  def start_link(name) do
    GenServer.start_link(__MODULE__, Handlers.handlers, [name: name])
  end

  # Public API

  def add_command(cmd_name, module, env_reqs \\ []) do
    GenServer.call(__MODULE__, {:add_command, cmd_name, module, env_reqs})
  end

  def command(cmd_name, cmd_arguments \\ %{}, cmd_env \\ %{}) do
    GenServer.call(__MODULE__, {:command, cmd_name, cmd_arguments, cmd_env})
  end

  # Private API

  def handle_call({:add_command, cmd_name, module, reqs}, _from, _) do
    handlers = Handlers.add_handler(cmd_name, {module, reqs})

    {:reply, handlers, handlers}
  end

  def handle_call({:command, cmd_name, cmd_arguments, cmd_env}, _from, handlers) do
    result = case handlers[cmd_name] do
      nil -> {:error, :unknown_command}
      { module, reqs } -> if reqs_met?(cmd_env, reqs) do
        cmd_response(module.execute(cmd_arguments, cmd_env))
      else
        {:error, :requirements_not_met}
      end
    end

    {:reply, result, handlers}
  end

  defp cmd_response(return_value) do
    case return_value do
      :ok -> :ok
      {:error, _} -> return_value
      _ -> {:error, :invalid_return}
    end
  end

  defp reqs_met?(_env, []), do: true
  defp reqs_met?(env, reqs), do: (reqs |> Enum.all?(&(env[&1])))
end

