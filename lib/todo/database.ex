defmodule Todo.Database do
  @pool_size 5

  def child_spec(_) do
    File.mkdir_p!(db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: 5
      ],
      [db_folder]
    )
  end

  def store(key, data) do
    {_results, bad_nodes} =
      :rpc.multicall(
        __MODULE__,
        :store_local,
        [key, data],
        :timer.seconds(5)
      )

    Enum.each(bad_nodes, &IO.puts("Store failed on node #{&1}"))
    :ok
  end

  def store_local(key, data) do
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

  defp db_folder do
    "./#{Application.get_env(:todo, :database_folder)}/#{node_name()}"
  end

  defp node_name do
    "#{node()}" |> String.split("@") |> hd()
  end
end
