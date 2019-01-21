defmodule Seed do
  def init_data do
    {:ok, cache_pid} = Todo.Cache.start()
    a = Todo.Cache.server_process(cache_pid, "alexs list")
    b = Todo.Cache.server_process(cache_pid, "bobs list")
    c = Todo.Cache.server_process(cache_pid, "clairs list")

    Enum.each(1..500, fn i ->
      Todo.Server.add_entry(a, %{date: ~D[2018-12-19], title: "Dentist_a_#{i}"})
      Todo.Server.add_entry(b, %{date: ~D[2018-12-19], title: "Dentist_b_#{i}"})
      Todo.Server.add_entry(c, %{date: ~D[2018-12-19], title: "Dentist_c_#{i}"})
    end)
  end
end
