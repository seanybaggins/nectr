FROM jenkins/jenkins:lts-alpine

# Disable the setup wizard
#ENV JAVA_OPTS -Dorg.eclipse.jetty.server.Request.maxFormContentSize=100000000 \
# 			  -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Denver \
# 			  -Dhudson.diyChunking=false \
# 			  -Djenkins.install.runSetupWizard=false

# Copy the admin user creation script
#COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

#COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
#RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#ENV JENKINS_OPTS --httpsPort=8443 --httpsKeyStore=/var/jenkins_home/jenkins_keystore.jks
