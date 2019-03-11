defmodule Todo.Database do
  @db_folder "./persist"
  @pool_size 3

  def child_spec(_) do
    File.mkdir_p!(@db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: 5
      ],
      [@db_folder]
    )
  end

  def store(key, data) do
    :poolboy.transaction(
      __MODULE__,
      fn pid -> Todo.DatabaseWorker.store(pid, key, data) end,
      10000
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn pid -> Todo.DatabaseWorker.get(pid, key) end
    )
  end
end
