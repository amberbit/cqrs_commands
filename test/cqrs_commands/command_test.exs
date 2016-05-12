defmodule Cqrs.TestCommand.Form do
  defstruct field: nil

  use Cqrs.Command.Form

  validates :field, presence: true
end

defmodule Cqrs.TestCommand do
  use Cqrs.Command

  def execute(args, _env \\ %{}) do
    form = Form.new(args)

    if Form.valid?(form) do
      :ok
    else
      {:error, Form.errors(form)}
    end
  end
end

defmodule Cqrs.CommandTest do
  use ExUnit.Case
  alias Cqrs.TestCommand

  test "can be initialized with string-based parameters" do
    :ok = TestCommand.execute(%{"field" => "hello"})
  end

  test "can be initialized with atom-based parameters" do
    :ok = TestCommand.execute(%{field: "hello"})
  end

  test "performs validations and returns errors" do
    {:error, _errors} = TestCommand.execute(%{field: nil})
    {:error, _errors} = TestCommand.execute(%{})
  end
end


