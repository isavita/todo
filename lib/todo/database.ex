defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"
  @workers_count 3

  def start(db_folder \\ @db_folder)
  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(db_folder) do
    File.mkdir_p!(db_folder)

    {:ok, init_workers(db_folder)}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _from, workers) do
    worker_key = :erlang.phash2(key, 3)

    {:reply, Map.get(workers, worker_key), workers}
  end

  defp init_workers(db_folder) do
    for i <- 0..(@workers_count - 1), into: %{} do
      {:ok, worker} = Todo.DatabaseWorker.start(db_folder)

      {i, worker}
    end
  end
end
