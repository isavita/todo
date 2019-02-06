defmodule EchoServer do
  use GenServer

  # Client

  def start_link(id) do
    GenServer.start_link(__MODULE__, :ok, name: via_tuple(id))
  end

  def echo(id, message) do
    GenServer.call(via_tuple(id), {:echo, message})
  end

  # Callbacks

  @impl true
  def init(:ok) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:echo, message}, _from, state) do
    {:reply, message, state}
  end

  defp via_tuple(id) do
    {:via, Registry, {:registry, {__MODULE__, id}}}
  end
end
