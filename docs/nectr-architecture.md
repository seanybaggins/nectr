# nectr AWS Deployment Architecture

## System Context

## System Architecture

![System Block Diagram](images/nectr-block-diagram.png)

### AWS Instances

nectr is built using a Jenkins host/slave architecture.  The [Host Server](#nectr-host-server) is a low cost webserver allowing a few users to configure automated builds.  It leverages [Slave Servers](#nectr-slave-server) deployed on high performance instances.  The slave servers are started and terminated as needed in order to minimize cost.

#### nectr Host Server

The nectr host server is a low cost, low performance Jenkins webserver behind an nginx webserver/proxy.  This is deployed via a docker stack as described in the `.../docker/stacks` directory.

##### Runtime

###### INS-2 - AWS T2.micro Instance

Allows a small number of users to interact with the Jenkins webserver.  Easily upgradable to something larger should performance be lacking.

See [AWS Documention](https://aws.amazon.com/ec2/instance-types/t2/) for pricing and specs.

###### AMI-2 - nectr_jenkins

A custom AMI with a webserver configured for running a docker stack.  Launched on INS-2.

###### IMG-1 - nectr_jenkins

An LTS version of [jenkins](https://hub.docker.com/r/jenkins/jenkins/).

###### IMG-2 - nectr_nginx

An [nginx](https://hub.docker.com/_/nginx) webserver configured to mandate/apply https.

##### Persistent Storage

Provided by AWS S3.  Access is limited by [AWS IAM](https://aws.amazon.com/iam/) account authorization.  Secrets are stored as described in the Secrets section.

###### S3-2 - jenkins_home

Persistent data for Jenkins.  User data, project data, etc.

###### S3-3 - nectr_keys

A catch-all for keys not handled within their application.  Currently houses the https certificate.

##### Secrets

###### SEC-1 - https Certificate

###### SEC-2 - AWS IAM EC2 User

###### SEC-3 - AWS IAM S3 User - nectr_deploy

###### SEC-4 - AWS IAM S3 User - nectr_persistent

###### SEC-5 - AWS IAM S3 User - nectr_keys

#### nectr Slave Server

##### Runtime

###### INS-1 - AWS C5.9xlarge Instance

A large AWS instance for running Jenkins slaves

###### AMI-1 - Jenkins Slave / Docker / Rake

##### Persistent Storage

###### S3-1 - nectr_deploy

Bucket for build artifacts and releases.  Credentials are provided by Jenkins Host instance

##### Secrets

None; all provided by host.
