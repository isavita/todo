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
    {:ok, %{}}
  end

  @impl true
  def handle_call({:register, name}, _, state) do
    pid = Process.whereis(name)

    response =
      if Map.has_key?(state, name) do
        :error
      else
        Process.link(pid)
        :ok
      end

    {:reply, response, Map.put_new(state, name, pid)}
  end

  @impl true
  def handle_call({:whereis, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  @impl true
  def handle_info({:EXIT, pid, reason}, state) do
    state =
      case Enum.find(state, fn {_key, value} -> value == pid end) do
        {name, _pid} -> Map.delete(state, name)
        nil -> state
      end

    {:noreply, state}
  end
end
