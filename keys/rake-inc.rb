namespace :local_ssl do
  keyfile = File.join(__dir__, 'nginx.key')
  crtfile = File.join(__dir__, 'nginx.crt')
  desc "Create a self-signed ssl cert"
  task :keygen do
    if File.exist?(keyfile)
      puts 'local_ssl certs already exist'
    else
      sh "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout #{keyfile} -out #{crtfile}"
    end
  end
end
