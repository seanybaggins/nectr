/*
 * Create an admin user.
 */
import jenkins.model.*
import hudson.security.*

println "--> creating admin user"

def adminUsername = new File("/run/secrets/jenkins-user").text.trim()
def adminPassword = new File("/run/secrets/jenkins-pass").text.trim()
assert adminPassword != null : "No jenkins-user secret provided, but required"
assert adminPassword != null : "No jenkins-pass secret provided, but required"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(adminUsername, adminPassword)
Jenkins.instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
Jenkins.instance.setAuthorizationStrategy(strategy)

Jenkins.instance.save()
