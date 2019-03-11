defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.ProcessRegistry,
        Todo.Database,
        %{id: Todo.Cache, start: {Todo.Cache, :start_link, []}}
      ],
      strategy: :one_for_one
    )
  end
end
