namespace :local_ssl do
  keystore_file = File.join(__dir__, "jenkins-keystore.jks")
  keypass_file = File.join(__dir__, "jenkins-keypass")

  def random_password(file)
    sh "head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c 13 > #{file}"
  end

  desc "Generate the keystore password"
  task :keypass do
    if File.exists?(keypass_file)
      puts "Keypass file already exists."
    else
      random_password(keypass_file)
    end
  end

  desc "Generate a local keystore key"
  task :keystore do
    if File.exists?(keystore_file)
      puts "Keystore file already exists.  Remove it with 'local_ssl:clean'"
    else
      sh "keytool -genkey -keyalg RSA -alias selfsigned -keystore #{keystore_file} -storepass herpderp -keysize 2048"
    end
  end

  desc "Clean the local_ssl keys"
  task :clean do
    rm keystore_file
    rm keypass_file
  end
end
