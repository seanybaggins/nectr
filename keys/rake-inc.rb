namespace :local_ssl do
  local_ssl_dir = File.join(__dir__, 'local_ssl')
  keyfile = File.join(local_ssl_dir, 'nginx.key')
  crtfile = File.join(local_ssl_dir, 'nginx.crt')
  desc "Create a self-signed ssl cert"
  task :keygen do
    if File.exist?(local_ssl_dir)
      puts 'local_ssl certs already exist'
    else
      mkdir local_ssl_dir
      sh "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout #{keyfile} -out #{crtfile}"
    end
  end

  desc "Clean self-signed ssl cert"
  task :clean do
    rm_rf local_ssl_dir
  end
end
