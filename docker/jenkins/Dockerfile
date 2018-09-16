FROM jenkins/jenkins:lts

ENV JAVA_OPTS -Dorg.eclipse.jetty.server.Request.maxFormContentSize=100000000 \
 			  -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Denver \
 			  -Dhudson.diyChunking=false \
 			  -Djenkins.install.runSetupWizard=false
