defmodule Todo.Application do
  use Application

  @impl true
  def start(_type, _args) do
    """
    children = [
      %{
        id: Todo.System,
        start: {Todo.System, :start_link, [nil]}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
    """
    Todo.System.start_link()
  end
end
