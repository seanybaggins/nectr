def launch_stack(name)
  p = File.join(__dir__, "#{name}.yml")
  sh "docker stack deploy -c #{p} #{PROJECT_NAME}-#{name}"
end

def stop_stack(name)
  sh "docker stack rm #{PROJECT_NAME}-#{name}"
end

namespace :local_http do
  desc "Launch the Jenkins container on localhost at port 8080"
  task :launch => ["docker:containers:jenkins:build"] do
    launch_stack("local-http")
  end

  desc "Stop the nectr-local-http stack"
  task :stop do
    stop_stack("local-http")
  end
end
