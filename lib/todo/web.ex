defmodule Todo.Web do
  use Plug.Router

  @http_port Application.get_env(:todo, :http_port)

  plug :match
  plug :dispatch

  post "/add_entry" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    title = Map.fetch!(conn.params, "title")
    date = get_date(conn.params, today)

    add_entry_to_list(list_name, title, date)

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "OK")
  end

  get "/entries" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    date = get_date(conn.params)
    entries = fetch_entries(list_name, date)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, Poison.encode!(entries))
  end

  defp get_date(params, default \\ nil) do
    case (Map.get(params, "date") || default) do
      nil -> nil
      date -> Date.from_iso8601!(date)
    end
  end

  defp add_entry_to_list(list_name, title, date) do
    list_name
    |> Todo.Cache.server_process()
    |> Todo.Server.add_entry(%{title: title, date: date})
  end

  defp fetch_entries(list_name, nil) do
    list_name
    |> Todo.Cache.server_process()
    |> Todo.Server.entries()
  end

  defp fetch_entries(list_name, date) do
    list_name
    |> Todo.Cache.server_process()
    |> Todo.Server.entries(date)
  end

  defp today do
    DateTime.utc_now() |> DateTime.to_date() |> Date.to_string()
  end

  def child_spec(_opts) do
    Plug.Adapters.Cowboy2.child_spec(
      scheme: :http,
      options: [port: @http_port],
      plug: __MODULE__
    )
  end

  def init(_opts) do
    IO.puts("Start to-do web server")
  end
end
