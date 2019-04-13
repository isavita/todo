remote_host = :todo_system@localhost
if Node.connect(remote_host) == true do
  case :rpc.call(remote_host, System, :stop, []) do
    :ok -> IO.puts("Node terminated." )
    error -> IO.puts("Cannot terminate remote node #{remote_host}. Reason: #{IO.inspect(error)}")
  end
else
  IO.puts("Cannot connect to remote node #{remote_host}.")
end
