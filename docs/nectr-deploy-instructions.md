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

#### SEC-1 SSL Certificate

Install Certbot

```bash
curl -O http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y epel-release-latest-7.noarch.rpm
sudo yum install -y certbot
```

### Start Application Stack



## Configure Jenkins Slave
