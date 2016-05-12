# forward "/api/commands", Cqrs.Commands.Plug, [base_path: "/api/commands"]
defmodule Cqrs.Commands.Plug do
  alias Cqrs.Commands.Server
  use Plug.Router
  use Plug.ErrorHandler

  plug :match
  plug :dispatch

  post "/" do
    command = conn.params["command"]
    arguments = conn.params["arguments"] || %{}

    response = Server.command(command, arguments, conn.assigns[:cqrs_command_env] || %{})

    conn
    |> put_resp_content_type("application/json")
    |> send_response_json(response)
  end

  def send_response_json(conn, :ok) do
    data = %{data: :ok}
    send_resp(conn, 200, encoder().encode_to_iodata!(data))
  end

  def send_response_json(conn, {:error, message}) when is_atom(message) do
    data = %{data: %{error: message}}
    send_resp(conn, 400, encoder().encode_to_iodata!(data))
  end

  def send_response_json(conn, {:error, messages}) do
    data = %{data: %{errors: messages}}
    send_resp(conn, 422, encoder().encode_to_iodata!(data))
  end

  defp encoder do
    (Application.get_env(:phoenix, :format_encoders) || [])
    |> Keyword.get(:json, Poison)
  end
end

