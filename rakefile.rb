PROJECT_NAME = "nectr"

def subdirectory_names(path)
  Dir.entries(path).select { |e| !(e.start_with?(".")) and (File.directory? File.join(path, e))}
end

def subdirctory_paths(path)
  subdirectory_names(path).map { |d| File.join(path, d) }
end

namespace :docker do
  require_relative "docker/rake-inc.rb"
end


namespace :keys do
  require_relative "keys/rake-inc.rb"
end
