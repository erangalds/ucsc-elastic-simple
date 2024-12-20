# Setting up a Single Node Elasticsearrch Cluster

## Instructions to Setup a Virtualization Platform
The virtual elasticsearch platform can be installed on either Oracle VirtualBox virtualization platform or Microsoft Hyper-V platform

The installation and most of the configuration is fully automated except for setting up the Service Token using a infrastructure as a code platform called Vagrant. Vagrant is a software from HarshiCorp Software foundation. We have to download and install the latest Vagrant software into your desktop. Vagrant is supported on both Windows and Linux. 

Once Vagrant and the Virtualization Hypervisor Platform is ready, we have to just run the below command. 

Microsoft Hyper-V
Start the Windows Command Prompt or PowerShell Terminal or New Windows Terminal in Administrator mode (Elivated Mode)

```dos
vagrant up --provider hyperv
```


Oracle VirtualBox
```dos
vagrant up 
```

Once the installation is done. We have to look at the installation log and get the auto generated password for the elastic user. Keep that copied safely. But anyway we are going to reset that password to a common password for use of use. 

Let's check for the basic network configuration in the operating system

```bash
# Check whether the host name is properly set
sudo hostname
# Check whether the hosts file is properly configured
sudo cat /etc/hosts
# Check whether the hostname is resolvable
sudo ping elk-single-node
# Now let's try to get the default route setting obtained from dhcp
sudo ip route | grep default
# Now let's see the ip address
sudo ip addr
# Check for internet connectivity
sudo ping bing.com
```


## Completing the Full Configuration of the ***Elasticasearch Single Node Cluster with Beats***
The installation autogenerates a password for the builtin admin user - elastic. But since I had to automate most of the configurations in the elasticsearch lab setup, we need to change that autogenerated password into ucsc@1234

```bash
cd scripts/manually-configure
# let's check for the available scripts
ls -al 
# Run the full setup script
# This script will perform all the required configurations
./full-setup.sh

```
The full-setup script will take few minutes to finish the installation. Once the installation is done, open the local browser and try to access the Kibana UI 

![Kibana UI](/images/01-kibana-ui.png)

### NOTE
If you face an error in starting Kibana and Beats Services, please below steps to troubleshoot them. 

Check whether `kibana.service` is running on not

```bash
sudo systemctl status kibana.service
```

If `kibana.service` is not running then we need to find out why its not working. Therefore we have to look at the `systemd` *logs* 

```bash
sudo journalctl -u kibana.service
```

Check whether you see below error. 

![Kibana Error](/images/20-kibana-error-dns-result-order.png)

If that is the error, then follow the below steps to resolve the error. 

+ Step 1 - Go to `/lib/systemd/system` folder
+ Step 2 - Edit the `kibana.service` file and enter the line `Environment="NODE_OPTIONS=--dns-result-order=ipv4first"` under the `[service]` section of the file. 
+ Step 3 - Then *reload* the config file with `sudo systemctl daemon-reload` and then *restart* the service `sudo systemctl restart kibana.service`
+ Step 4 - Next check Beats Services with `sudo systemctl status filebeat.service` if not started we can try to restart `sudo systemctl restart filebeat.service`
+ Step 5 - Restart all the other beats similarly 
    + Metric Beat : `sudo systemctl restart metricbeat.service` 
    + Audit Beat : `sudo systemctl restart auditbeat.service`  
    + Packet Beat : `sudo systemctl restart packetbeat.service`






