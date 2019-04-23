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


namespace :nginx do
  desc "Build the nginx container"
  task :build do
    build_container("nginx")
  end
end

desc "Build all containers"
task :build_all => ["nginx:build", "jenkins:build"]
