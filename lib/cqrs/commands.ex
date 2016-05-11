defmodule Cqrs.Commands do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(Cqrs.Commands.Handlers, [Cqrs.Commands.Handlers]),
      worker(Cqrs.Commands.Server, [Cqrs.Commands.Server]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cqrs.Commands.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
