def build_container(name)
  p = File.join(__dir__, name)
  sh "docker build -t #{PROJECT_NAME}-#{name} #{p}"
end

namespace :jenkins do
  desc "Build the Jenkins server"
  task :build do
    build_container("jenkins")
  end
end


namespace :http_forwarding do
  desc "Build the http-forwarding container"
  task :build do
    build_container("http-forwarding")
  end
end

desc "Build all containers"
task :build_all => ["http_forwarding:build", "jenkins:build"]
