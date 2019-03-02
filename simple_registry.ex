defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def register(name) do
    GenServer.call(__MODULE__, {:register, name})
  end

  def whereis(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, pid}] -> pid
      _ -> nil
    end
  end

  # Callbacks

  @impl true
  def init(:ok) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:set, :public, :named_table, read_concurrency: true, write_concurrency: true])

    {:ok, nil}
  end

  @impl true
  def handle_call({:register, name}, _from, state) do
    pid = Process.whereis(name)

    response =
      if :ets.insert_new(__MODULE__, {name, pid}) do
        Process.link(pid)
        :ok
      else
        :error
      end

    {:reply, response, state}
  end

  @impl true
  def handle_info({:EXIT, pid, _reason}, state) do
    :ets.match_delete(__MODULE__, {:_, pid})

    {:noreply, state}
  end
end
