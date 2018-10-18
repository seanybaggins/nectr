# Jenkins on AWS Fargate

Host OS: Ubuntu 18.04

## AWS command line

### Install

`sudo snap install aws-cli --classic`

### Create Access Key for Host OS

Go to the [IAM User Console](https://console.aws.amazon.com/iam/home?#/users)

Click `Add User`

* User Name: I generally tie this to the machine and user, so in my case I name my user `kylo-adam`
* Access Type: Programmatic access

Add the following permissions:

* AmazonEC2ContainerRegistryFullAccess
* AdministratorAccess
* AmazonECS_FullAccess

### Install Access Key for Host OS

Run `aws configure`

Enter the Access Key ID and Secret Access Key provided on the AWS console.

Default region name `us-east-2`

Default output format `None`

## Configure Jenkins Image for ECS

### Create ECR Registry

`aws ecr create-repository --repository-name nectr-jenkins --region us-east-2`

Save the repository URL provided.  In this case, it's `589290264779.dkr.ecr.us-east-2.amazonaws.com/nectr-jenkins`

### Create your self-signed keys

`keytool -genkey -keyalg RSA -alias selfsigned -keystore .../keys/jenkins_keystore.jks -storepass mypassword -keysize 2048`

### Log in to ECR's Docker interface

`$(aws ecr get-login --no-include-email)`

### Build the jenkins container

`docker build -t nectr-jenkins .../docker/jenkins`

## Run the container locally

#### Create admin credentials

`echo *DESIRED_USERNAME* | docker secret create jenkins-user -`

`echo *DESIRED_PASSWORD* | docker secret create jenkins-pass -`

These need to be secure.  Best practice would be to generate it with a secure password manager.

#### Deploy the stack

`docker stack deploy -c .../docker/jenkins/local-stack.yml nectr-jenkins`

#### Stop the stack

`docker stack rm nectr-jenkins`

## ECS Build

### Cluster Setup

Go to the [ECS Clusters Console](https://us-east-2.console.aws.amazon.com/ecs/home?region=us-east-2#/clusters)

Click `Create Cluster`

Pick `Networking Only`

Name the cluster `nectr`

Check `create VPC` and use the default settings

### Configure Jenkins

Install the following plugins:

* EC2
* ECS
* ECS Publisher

Create a new IAM key

Name: nectr-jenkins

Add Credentials:

* AmazonEC2AmazonEC2ContainerRegistryFullAccess
* AmazonECS_FullAccess
* AmazonECSTaskExecutionRolePolicy
