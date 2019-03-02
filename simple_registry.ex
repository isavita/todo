defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def register(name) do
    GenServer.call(__MODULE__, {:register, name})
  end

  def whereis(name) do
    GenServer.call(__MODULE__, {:whereis, name})
  end

  # Callbacks

  @impl true
  def init(:ok) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:set, :public, :named_table])

    {:ok, %{}}
  end

  @impl true
  def handle_call({:register, name}, _, state) do
    pid = Process.whereis(name)

    response =
      if :ets.insert_new(__MODULE__, {name, pid}) do
        Process.link(pid)
        :ok
      else
        :error
      end

    {:reply, response, Map.put_new(state, name, pid)}
  end

  @impl true
  def handle_call({:whereis, name}, _from, state) do
    response =
      case :ets.lookup(__MODULE__, name) do
        [{_name, pid}] -> pid
        _ -> nil
      end

    {:reply, response, state}
  end

  @impl true
  def handle_info({:EXIT, pid, reason}, state) do
    IO.inspect(reason)
    :ets.match_delete(__MODULE__, {:"$1", pid})

    {:noreply, state}
  end
end
