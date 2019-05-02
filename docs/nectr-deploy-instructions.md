# nectr Deploy Instructions

Assumptions:

- I use us-east2; you'll need to replace this with your own region.

## Webserver Setup

### Start EC2 Instance

To make the nectr_host webserver, begin by spinning up an AWS T2.Micro instance of a baseline AMI.

- Load the [AWS EC2 Console](https://console.aws.amazon.com/ec2) and click "Launch Instance"
- Select a minimal AWS Linux instance: `Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-02bcbb802e03574ba`
- Modify the network settings as needed (I use the default).
- Storage
  - Use the default root configuration
  - Create a 1GB EBS volume and mount it at `/dev/sdb`.  This will be the secure key storage.
  - Create a 10GB EBS volume at `/dev/sdc`.  This will be the persistent data storage.
- Launch the instance
- Allocate an IP address and assign it to your instance.
- SSH into the instance with `ssh -i *YOUR_PEM_FILE* ec2-user@*INSTANCE_IP_ADDRESS*`

### Provision Host

```bash
# Install required packages
sudo yum update -y
sudo amazon-linux-extras install docker
sudo yum install git rake

# Initialize our key storage volume
sudo fdisk /dev/sdb
# Create the partition with "n", use default for the rest, exit with "w"
sudo fdisk /dev/sdc
# Create the partition with "n", use default for the rest, exit with "w"
sudo mkfs.ext4 /dev/sdb1
sudo mkfs.ext4 /dev/sdc1

# Mount our volumes
sudo mkdir /var/nectr_keys /var/nectr_persistent
sudo mount /dev/sdb1 /var/nectr_keys
sudo mount /dev/sdc1 /var/nectr_persistent

```

### Open http/https to instance

- Load the EC2 Console
- Right-click the instance, choose networking->change security groups
- Create/assign a security group allowing incoming http/https traffic **TODO: Verify this is limited to the sync VPN**

#### SEC-1 SSL Certificate

Install Certbot

```bash
curl -O http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y epel-release-latest-7.noarch.rpm
sudo yum install -y certbot
```

Generate your cert by running ` sudo certbot --standalone certonly` and following the directions.

Install your cert by executing

```bash
sudo mkdir -p /var/nectr_keys/ssl
sudo cp /etc/letsencrypt/live/${YOUR_DOMAIN}/fullchain.pem /var/nectr_keys/ssl/nginx.crt
sudo cp /etc/letsencrypt/live/${YOUR_DOMAIN}/privkey.pem /var/nectr_keys/ssl/nginx.key
sudo chmod 655 -R /var/nectr_keys/ssl
```

#### Create non-root user

Create a user without root permissions, give it ownership of the nectr_persistent directory, and add it to the docker group.

```bash
sudo adduser nectr
sudo chown nectr:nectr /var/nectr_persistent
sudo usermod -aG docker nectr
```

Now start the Docker daemon

```bash
sudo service docker start
sudo systemctl enable docker
```

Log in as your user and verify that you can run Docker

```bash
su nectr
docker --version
```

### Start Application Stack

**TODO: Create yml stack for your domain**

Log in as your non-root user and change to the home directory

```bash
su nectr
cd
```

Pull the repository

```bash
git clone git clone https://github.com/PseudoDesign/nectr.git
```

Create a new swarm for deploying the stack, then deploy it

```bash
docker stack init
rake docker:stacks:nectr_dev:launch
```


Launch the stack with

```bash
rake docker:stacks:nectr_dev:launch
```

Get the logs with `docker service logs nectr-nectr-dev_nginx` (or jenkins, or default)

## Configure Jenkins Host

### Create Admin Account

Once launched, you should see the Unlock Jenkins screen prompting you for a password from the logs files.

![](images/unlock_jenkins.png)

Get this from the SSH terminal by executing `sudo cat /var/nectr_persistent/secrets/initialAdminPassword`, then terminate the SSH connection.  It is no longer needed.

### Disable SSH Access to Server

Once the Docker stack is running, the SSH connection is no longer needed.

- Load the EC2 Console
- Right-click the instance, choose networking->change security groups
- Remove the launch wizard / SSH group from this instance.

## Configure Jenkins Slave
