defmodule Todo.Server do
  use GenServer, restart: :temporary

  @idle_timeout :timer.seconds(10)

  def start_link(name) do
    IO.puts("Starting to-do server #{IO.inspect(name)}.")
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def add_entry(server_pid, entry) do
    GenServer.cast(server_pid, {:add_entry, entry})
  end

  def entries(server_pid) do
    GenServer.call(server_pid, :all_entries)
  end

  def entries(server_pid, on) do
    GenServer.call(server_pid, {:get_entries, on})
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  @impl GenServer
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}, @idle_timeout}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, {name, todo_list}) do
    new_todo_list = Todo.List.add_entry(todo_list, entry)
    Todo.Database.store(name, new_todo_list)
    {:noreply, {name, new_todo_list}, @idle_timeout}
  end

  @impl GenServer
  def handle_call(:all_entries, _from, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list), {name, todo_list}, @idle_timeout}
  end

  @impl GenServer
  def handle_call({:get_entries, on}, _from, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, on), {name, todo_list}, @idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, {name, todo_list}) do
    IO.puts("Stopping to-do server for #{name}")
    {:stop, :normal, {name, todo_list}}
  end
end
