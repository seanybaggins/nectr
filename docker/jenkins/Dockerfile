FROM jenkins/jenkins:lts

# Disable the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Copy the admin user creation script
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
