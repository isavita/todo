Code.require_file("./simple_registry.ex")
SimpleRegistry.start_link()

start_time = DateTime.now("Etc/UTC") |> elem(1)

tasks = [Task.async(fn ->
  Enum.each(1..35_000, fn x ->
    name = :"task1_#{x}"
    Agent.start(fn -> 0 end, name: name)
    SimpleRegistry.register(name)
  end)
end)]

tasks = [Task.async(fn ->
  Enum.each(1..35_000, fn x ->
    name = :"task2_#{x}"
    Agent.start(fn -> 0 end, name: name)
    SimpleRegistry.register(name)
  end)
end) | tasks]

tasks = [Task.async(fn ->
  Enum.each(1..35_000, fn x ->
    name = :"task3_#{x}"
    Agent.start(fn -> 0 end, name: name)
    SimpleRegistry.register(name)
  end)
end) | tasks]

tasks = [Task.async(fn ->
  Enum.each(1..35_000, fn x ->
    name = :"task4_#{x}"
    Agent.start(fn -> 0 end, name: name)
    SimpleRegistry.register(name)
  end)
end) | tasks]

tasks = [Task.async(fn ->
  Enum.each(1..35_000, fn x ->
    name = :"task5_#{x}"
    Agent.start(fn -> 0 end, name: name)
    SimpleRegistry.register(name)
  end)
end) | tasks]

tasks = [Task.async(fn ->
  Enum.each(1..35_000, fn x ->
    name = :"task6_#{x}"
    Agent.start(fn -> 0 end, name: name)
    SimpleRegistry.register(name)
  end)
end) | tasks]

Task.yield_many(tasks)

end_time = DateTime.now("Etc/UTC") |> elem(1)

DateTime.diff(end_time, start_time, :microsecond) |> Kernel./(1000) |> (&IO.puts("#{&1} ms")).()
