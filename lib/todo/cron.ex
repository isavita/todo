defmodule Todo.Cron do
  use Supervisor

  alias Todo.Metrics

  def start_link(_opts) do
    IO.puts("Start Cron")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init(:ok) do
    children = [
      %{
        id: Metrics,
        start: {Metrics, :start_link, [nil]},
        restart: :transient
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
