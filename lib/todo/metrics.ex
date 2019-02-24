defmodule Todo.Metrics do
  use Task

  @time_step 5

  def start_link(_opts), do: Task.start_link(&loop/0)

  def loop do
    Process.sleep(:timer.seconds(@time_step))
    IO.inspect(collect_metrics())
    loop()
  end

  defp collect_metrics do
    [
      memory_usage: "#{Float.round(:erlang.memory(:total) / (1024 * 1024), 3)} MB",
      process_count: :erlang.system_info(:process_count)
    ]
  end
end
