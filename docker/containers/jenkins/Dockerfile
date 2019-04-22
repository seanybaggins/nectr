FROM jenkins/jenkins:lts-alpine

ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8443 --httpsCertificate=/var/nectr-keys/fullchain.pem --httpsPrivateKey=/var/nectr-keys/privkey-rsa.pem

USER ${user}
