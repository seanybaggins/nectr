# nectr Deploy Instructions

Assumptions:

- I use us-east2; you'll need to replace this with your own region.

## Create AMIs

### AMI Setup

To make the nectr_host and nectr_jenkins_slave AMIs, begin by spinning up an AWS T2.Micro instance of a baseline AMI.

- Load the [AWS EC2 Console](https://console.aws.amazon.com/ec2) and click "Launch Instance"
- Select a minimal AWS Linux instance: `Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-02bcbb802e03574ba`
- Modify the remaining settings as needed (I use the default).
- Launch the instance, SSH in, and run the setup scripts provided below.

### Provision AMI

#### nectr_host

```bash

```

#### nectr_jenkins_slave

```bash

```

## Deploy Host

### Host Secrets

#### SEC-5 nectr_keys/ssl S3 Bucket

#### SEC-1 SSL Certificate


## Create AWS IAM Users

### SEC-2

### SEC-3

### SEC-4

### SEC-5
