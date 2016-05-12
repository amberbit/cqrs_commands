# forward "/api/commands", Cqrs.Commands.Plug, [base_path: "/api/commands"]
defmodule Cqrs.Commands.Plug do
  use Plug.Router

  post "/" do
    IO.inspect conn

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "wat")
  end
end
