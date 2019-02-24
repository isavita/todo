defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.Cron,
        Todo.ProcessRegistry,
        %{id: Todo.Database, start: {Todo.Database, :start_link, []}},
        %{id: Todo.Cache, start: {Todo.Cache, :start_link, []}}
      ],
      strategy: :one_for_one
    )
  end
end
