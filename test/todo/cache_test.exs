defmodule Todo.CacheTest do
  use ExUnit.Case

  alias Todo.Cache

  describe "server_process/1" do
    test "starts todo list server if hasn't been started and returns it's pid" do
      assert is_pid(Cache.server_process("Random list of things"))
    end

    test "returns todo list server pid if it has been started" do
      todo_list_pid = Cache.server_process("Another Random list of things")

      assert todo_list_pid == Cache.server_process("Another Random list of things")
    end
  end
end
