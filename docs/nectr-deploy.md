# Deploying OE-Build on AWS with nectr

## Spin up nectr-jenkins

This is a public-facing Jenkins server, which manages builds.  

This is simply a Jenkins server Docker container with the SSL keys passed in via a bind mount, and a set of plugins installed.

### Create an AWS EC2 Instance

I just use the free (for the first year) T2.micro instance of Ubuntu.  Since this container launches other AWS instances, it doesn't need to be very powerful.

This can be done via the [EC2 Console](https://aws.amazon.com/console/).

### Launching nectr

#### SSL Configuration

SSL is necessary to secure transmission of login credentials.

##### Secure a domain

To avoid the webbrowser nagging about insecure SSL certs, one must secure a (sub)domain.  I generally use [Namecheap](https://www.namecheap.com/) to buy domains for whatever project I'm working on.

Point the A-Record of the domain to the IP address of your AWS EC2 instance.

##### Get SSL Certs

https://letsencrypt.org/

##### Convert certs to jks-format

##### Install

Copy the .jks file to the `.../keys` directory.  This directory is

#### Starting nectr

##### http Forwarding

The Docker deploy stack includes an http forwarding image.  See `.../docker/containers/http-forwarding`.  This container simply redirects all http traffic to https before forwarding it to the jenkins docker image (which is configured for https-only).

##### Persistent Data

*TODO: Do something smarter here, like S3 storage for JENKINS_HOME*

Replace the paths at `.../stacks/local-https.yml` with locations on your VM.

##### AWS Security Configuration

Open http/https ports via AWS console security groups.

##### Start the stack

`rake docker:stacks:local_https:launch`

Perform the jenkins first time setup and make an admin account.

# Configuring Jenkins Slaves

I've followed [this](https://www.cloudbees.com/blog/setting-jenkins-ec2-slaves) guide.

## Create custom AMI

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html

# Configure Jenkins/Github build hooks

https://www.cloudbees.com/blog/setting-jenkins-ec2-slaves

# Configuring github webhooks

https://support.cloudbees.com/hc/en-us/articles/224543927-GitHub-Integration-Webhooks

# Save build artifacts to S3

## Create an S3 Bucket

https://s3.console.aws.amazon.com/s3/

## Create IAM User

### Add IAM group permission

### Creatue user with group permissions

https://vnextcoder.wordpress.com/2016/10/25/part-3-storing-jenkins-output-to-aws-s3-bucket/
