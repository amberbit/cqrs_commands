defmodule Cqrs.Commands.ServerTest.LogInCommand do
  def execute(form, environment) do
    if form["email"] == "user@example.com" && form["password"] == "123password" do
      :ok
    else
      {:error, %{"password" => ["is not valid"]}}
    end
  end
end

defmodule Cqrs.Commands.ServerTest do
  use ExUnit.Case
  alias Cqrs.Commands.Server
  alias Cqrs.Commands.ServerTest.LogInCommand

  doctest Cqrs.Commands.Server

  setup do
    :application.stop(:cqrs_comnands)
    :application.start(:cqrs_commands)
    :ok
  end

  test "adds an event handler" do
    assert %{"LogIn" => { LogInCommand, []} } == Server.add_command "LogIn", LogInCommand
  end

  test "executes command handler" do
    Server.add_command "LogIn", LogInCommand

    :ok = Server.command("LogIn", %{"email" => "user@example.com", "password" => "123password"})
    {:error, _} = Server.command("LogIn", %{"email" => "user@example.com", "password" => ""})
  end

  test "notifies about unknown command" do
    {:error, :unknown_command} = Server.command("LetMeIn")
  end

  test "adds an event handler with environment requirement" do
    Server.add_command "LogIn", LogInCommand, [:domain]

    :ok = Server.command("LogIn", %{"email" => "user@example.com", "password" => "123password"}, %{domain: "example.com"})
    {:error, _} = Server.command("LogIn", %{"email" => "user@example.com", "password" => ""}, %{domain: "example.com"})
  end

  test "prevents unauthorized user from executing command handler without required environment specified" do
    Server.add_command "LogIn", LogInCommand, [:domain]

    {:error, :requirements_not_met} = Server.command("LogIn", %{"email" => "user@example.com", "password" => "123password"})
  end
end

