defmodule Cqrs.Commands.PlugTest.LogInCommand do
  def execute(arguments, _environment) do
    if arguments["email"] == "user@example.com" && arguments["password"] == "123password" do
      :ok
    else
      {:error, %{password: ["is not valid"]}}
    end
  end
end

defmodule Cqrs.Commands.PlugTest do
  use ExUnit.Case
  use Plug.Test
  alias Cqrs.Commands.Server
  alias Cqrs.Commands.PlugTest.LogInCommand

  defp call(conn) do
    Cqrs.Commands.Plug.call(conn, [])
  end

  setup do
    :application.stop(:cqrs_comnands)
    :application.start(:cqrs_commands)
    :ok
  end

  test "handles unknown commands properly" do
    %{resp_body: resp, status: status} = conn(:post, "/", %{"command" => "Foo", "arguments" => %{"email" => "a@b.com"}})|> call

    resp = Poison.decode!(resp)
    assert resp["data"]["error"] == "unknown_command"
    assert status == 400
  end

  test "handles successfull commands" do
    Server.add_command "LogIn", LogInCommand

    %{resp_body: resp, status: status} = conn(:post, "/", %{"command" => "LogIn", "arguments" => %{"email" => "user@example.com", "password" => "123password"}})|> call

    resp = Poison.decode!(resp)
    assert resp["data"] == "ok"
    assert status == 200
  end
end

