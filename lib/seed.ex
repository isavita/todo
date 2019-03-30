defmodule Seed do
  def init_data do
    start_todo_system()

    a = Todo.Cache.server_process("alexs list")
    b = Todo.Cache.server_process("bobs list")
    c = Todo.Cache.server_process("clairs list")

    Enum.each(1..50, fn i ->
      Todo.Server.add_entry(a, %{date: ~D[2018-12-19], title: "Dentist_a_#{i}"})
      Todo.Server.add_entry(b, %{date: ~D[2018-12-19], title: "Dentist_b_#{i}"})
      Todo.Server.add_entry(c, %{date: ~D[2018-12-19], title: "Dentist_c_#{i}"})
    end)
  end

  defp start_todo_system do
    unless todo_system_started? do
      {:ok, _} = Todo.System.start_link()
    end
  end

  defp todo_system_started? do
    Application.started_applications()
    |> Enum.any?(fn {module_name, _, _} -> module_name == :todo end)
  end
end
