# nectr Deploy Instructions

Assumptions:

- I use us-east2; you'll need to replace this with your own region.

## Webserver Setup

### Start EC2 Instance

To make the nectr_host webserver, begin by spinning up an AWS T2.Micro instance of a baseline AMI.

- Load the [AWS EC2 Console](https://console.aws.amazon.com/ec2) and click "Launch Instance"
- Select a minimal AWS Linux instance: `Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-02bcbb802e03574ba`
- Modify the network settings as needed (I use the default).
- Launch the instance
- Allocate an IP address and assign it to your instance.
- SSH into the instance with `ssh -i *YOUR_PEM_FILE* ec2-user@*INSTANCE_IP_ADDRESS*`

### Provision Host

Install the tools we will need for managing the server.

```bash
sudo yum update -y
sudo amazon-linux-extras install docker
sudo yum install git
```
Install docker compose by following the official docker compose instructions: https://docs.docker.com/compose/install/

### Open http/https to instance

- Load the EC2 Console
- Right-click the instance, choose networking->change security groups
- Create a security group allowing incoming http/https traffic 
- Name this security group `nectr-jenkins-host`

#### Updating the DNS
We will use docker to run a client that will make sure out domain name maps to the ip address of our machine.

- Clone this repo.
    ```bash
    cd $HOME
    git clone https://github.com/seanybaggins/nectr.git
    ```
- Fill out the `$HOME/nectr/stacks/get-cert.yml` file
    > Note: The only fields that need to be filled in will be encapsulated with `< >`.
- Make a file that we will use to store the configuration for our domain name service client
    ```bash
    mkdir $HOME/.config
    mkdir $HOME/.config/nectr
    mkdir $HOME/.config/nectr/ddclient
    nano $HOME/.config/nectr/ddclient/ddclient.conf
    ```
- Populate the `ddclient.conf` file with the appropriate information.
    > Note: Configuration values for the `ddclient.conf` will vary depending on your DNS provider. Be sure to look up ddclient config needed for your provider. Below is an example/template if the DNS provider was namecheap.
    ```bash
    # Relevant Documentation
    # https://www.khanacademy.org/computing/ap-computer-science-principles/the-internet/x2d2f703b37b450a3:web-protocols/a/domain-name-system-dns-protocol
    # https://ddclient.net/#configuration
    # https://www.namecheap.com/support/knowledgebase/article.aspx/583/11/how-do-i-configure-ddclient
    # https://fleet.linuxserver.io/image?name=linuxserver/ddclient

    # For simplicity. Assuming that Namecheap will be the DNS provider.
    # These values will be different if you are not using namecheap
    use=web, web=dynamicdns.park-your-domain.com/getip
    protocol=namecheap
    server=dynamicdns.park-your-domain.com

    # User Specific information.
    login=<second-level-domain>.<top-level-domain>
    password=<your-dns-dynamic-password> 
    <third-level-domain>
    ```
- Configure your DNS host for the ddclient. For namecheap, this involves creating a dyncamic DNS record for your domain. See the following documentation for using Dynamic DNS with namecheap.
  - https://www.namecheap.com/support/knowledgebase/article.aspx/36/11/how-do-i-start-using-dynamic-dns/
- Now that the domain name service client and host are properly configured, update your domain name with the ip of the AWS machine by running the following commands
    ```
    cd $HOME/nectr/docker/stacks
    docker-compose --file update-dns.yml up --build
    ```
    > Note: A log should appear and indicate either success of failure. Once success or failure is indicated, stop the ddclient by pressing `Ctrl+C`.
    > You can also use the [nslookup](https://linuxhandbook.com/nslookup-command/) command to verify your domain name is associated with an ip address.

#### Getting Certificates
Now that our domain name points to the IP address of our server, lets get a certificate from a trusted certificate authority so we can establish a secure/encrypted connection with our server.

- Open the `get-cert.yml` file and update the fields enclosed with `< >`.
- Get the certificate by running...

    ```bash
    cd $HOME/nectr/docker/stacks
    docker-compose --file get-cert.yml up --build
    ```
    > Note: You should get a log output indicating success or failure of obtaining the ssl cert.

#### Launching the Server
Now that we have certificates to establish secure connections, we are nearly ready to launch the server.
- Open the `$HOME/nectr/docker/stacks/launch-server.yml` file 
    ```bash
    cd $HOME/nectr/docker/stacks/
    nano launch-server.yml
    ```
  and fill in the required sections notated with `< >`.
- Open the `$HOME/nectr/docker/containers/nginx/nectr-nginx.conf` file
    ```bash
    cd $HOME/nectr/docker/containers/nginx/nectr-nginx.conf
    nano nectr-nginx.conf
    ```
    and fill out the required sections noted with `< >`.

- Launch the server by navigating to the stacks directory and using docker compose.
    ```bash
    cd $HOME/nectr/docker/stacks
    docker-compose --file launch-server.yml up --build
    ```
- In your browser, go to the domain name for your server. You should now see a response from Jenkins.
    > Note: If you would prefer the server stack not hog your terminal, you can stop the sever using `Ctrl+C` and relaunch it using 
    > ```bash
    > docker-compose --file launch-server.yml up --build --detach
    > ```
## Jenkins First Time Setup

### Create Admin Account

Once launched, you should see the Unlock Jenkins screen prompting you for a password from the logs files.

![](images/unlock_jenkins.png)

Get this from the SSH terminal by executing `docker exec -it nectr-jenkins cat /var/jenkins_come/secrets/initialAdminPassword`, then terminate the SSH connection.  It is no longer needed.

### Disable SSH Access to Server

Once the Docker stack is running, the SSH connection is no longer needed.

- Load the EC2 Console
- Right-click the instance, choose networking->change security groups
- Remove the launch wizard / SSH group from this instance.

### Configure User Accounts

**TODO**

### (Optional) Test SSL

For publicly-facing domains, you can test SSL with [SSL Labs](https://www.ssllabs.com/ssltest/analyze.html?d=nectr.dev).

## Configure Jenkins Slave

Install the Amazon EC2 Jenkins plugin.

![](images/ec2_plugin.png)

### Create an AMI

An [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) is a baseline machine image.  We'll launch our build environments in them and there may need to be many of them for various projects.

I already have a publicly available AMI for my projects, `ami-0074af1f2b320e13a`

We will likely need to make a govcloud version of this AMI.

### Create AWS IAM User

Use the [Identity and Access Management](https://console.aws.amazon.com/iam/home#/home) console to create a user with the exact permissions needed for the EC2 Plugin.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "JenkinsEC2",
            "Action": [
                "ec2:DescribeSpotInstanceRequests",
                "ec2:CancelSpotInstanceRequests",
                "ec2:GetConsoleOutput",
                "ec2:RequestSpotInstances",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstances",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:DescribeImages",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

This will generate an Access Key ID/Private Key pair.  Use this to create your Amazon EC2 Credentials in Jenkins.

### Create Security Group

Our slave instances will need a network security policy.  Create a new one with the EC2 console, named `nectr-jenkins-slave`.  Allow inbound traffic from port 22 of the `nectr-jenkins-host` security group.

### Slave Settings in Jenkins

The inline documentation describes this section better than I could; just use my settings for my AMI:

![](images/jenkins_ec2_settings.png)

For the private key, generate a unique key for this application using the EC2 console.

Online [guides](https://blog.iseatz.com/ec2-plugin-jenkins-automatically-provision-slaves/) explain the details of these settings.

## Add a Webhook to Jenkins

**TODO**

## Test a build

**TODO**