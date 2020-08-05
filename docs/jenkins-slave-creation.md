

# Creating AMI for Jenkins slaves -- LINUX
Navigate to the AWS EC2 console, by logging in and typing EC2 in the search bar.
![ec2 search](images/ec2_search.png)

Click the orange Launch instance button and select Launch instance.

Select the appropriate base distro to create your own image. Here we'll use Ubuntu Server 20.04 LTS(HVM), SSD Volume Type. Generallly, select the newest version unless otherwise needed.
![select distro](images/select_distro.png)

Select the appropriate instance type based on virtual CPUs/Memory size. For example, we'll use t2.micro. After selecting the right type, click Next until reaching the security group menu.
Click "Select an existing security group" and choose "ITAR-Sync-Only". Then click "Review and Launch". On the next page click "Launch".
![security group](images/security_group.png)

You will need to have a key pair for authentication (.ppk saved on your local machine). Choose your key pair and click "Launch Instance". Then click "View Instances". Locate your instance, right click -> Networking -> Manage IP Addresses and copy your private IP.

Once your instance is running, launch PuTTY to connect to it via ssh. Under host name paste your private IP. 
![ip_address](images/ip_address.png)

Then, under SSH->Auth, click Browse and locate your .ppk private key

![key](images/key.png)

Click "Open" and login as your distro's default user.
![login](images/login.png)

We'll need to install OpenJDK/JRE. Use your distro's package manager. In the case of Ubuntu, run:

`sudo apt-get update`

`sudo apt-get install openjdk-8-jdk`

After this, navigate to the etc directory by typing: 

`cd /`

`cd etc`

In this folder, type: 
`sudo chmod 644 resolv.conf`

Then, we need to edit this file. Using any text editor, open resolv.conf and change its contents to:


`options timeout:2 attempts:5`  
`; generated by /sbin/dhclient-script`  
`search us-gov-west-1.compute.internal`  
`nameserver 192.168.15.224`

Save the changes.

Now we can create a new AMI. Head back to the EC2 running instances console and right click on the created instance. Select Image -> Create Image.
![image](images/create_image.png)


In the box put in the disk size you want for your AMI, and uncheck the box saying "Delete on Termination". Then create the image.
![no_delete](images/no_delete.png)
Once the image has been made, the EC2 instance can be terminated.
![terminate](images/terminate.png)







# Creating AMI for Jenkins slaves -- WINDOWS

Launch the instance the same way as the linux instance but choose the Windows version you'd like instead of linux distro. Use the same security group.

To connect to the instance, we need to get the password. Right click on the instance and choose Connect -> Get Password. Click browse and find your private key  
![get_pass](images/get_password.png)
If you don't have your key in .pem format, follow these instructions:
https://www.ezeelogin.com/kb/article/how-to-convert-the-ppk-files-to-openssh-format-231.html


Once we have the password, we can remote desktop into our Windows instance.
Get your instance's private IP by right-clicking on it in EC2 and Netowrking->Manage IP Addresses. Open remote desktop and enter the IP. You'll want to log on as "Administrator". Enter the password we got earlier.  
![remote](images/remote.png)  
If you are prompted about unverified identity, click yes.  
Once remoted in, we can install java. Go to jdk.java.net and download the newest Ready for use JDK.

Extract the files to wherever you'd like. Now, type "env" into the windows search bar and select "Edit the system environment variables". Click the Environment Variables button.  
![env](images/env.png)  
 In both the system and user PATH variables, we need to add a line at the bottom with the path to the bin directory in your JDK installation. Then Click "New" under System Variables and create a variable with name "JAVA_HOME" and value of the path to your java directory (not including the bin subfolder).  
 ![variable](images/variable.png)
 Click OK/apply to all, then to verify the installation type `java --version` in a command prompt.  
   
 Now, to allow winRM, we need to edit some firewall rules. Open Windows Firewall from the search bar. Click Advanced Settings on the left. Click on "Inbound Rules", then "New Rule..." on the right. Select "Port" and click next. Choose "TCP" and "Specific Local Ports". Enter these ports and click next:  
 ![ports](images/ports.png)  
 Select Allow the connection and click next. Leave all three boxes checked and click next. Give the rule a name such as "winRM".


 # Creating slave machine from AMI