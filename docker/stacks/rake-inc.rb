def launch_stack(name)
  p = File.join(__dir__, name)
  sh "docker stack deploy -c #{p} #{PROJECT_NAME}-#{name}"
end

namespace :local_http do
  desc "Launch the Jenkins container on localhost at port 8000"
  task :launch => ["docker:containers:jenkins:build"] do
    launch_stack("local-http")
  end
end
