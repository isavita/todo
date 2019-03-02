defmodule EtsKeyValue do
  use Agent

  def start_link do
    Agent.start_link(
      fn ->
        :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
      end,
      name: __MODULE__
    )
  end

  def put(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] -> value

      [] -> nil
    end
  end
end
