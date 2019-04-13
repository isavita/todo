use Mix.Releases.Config, default_environment: :prod

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :todo
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :todo do
  set version: current_version(:todo)
end
