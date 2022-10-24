# Dataset-Pipeline Tool 
This tool is a Beta Virtual Appliance. 

This is a tool to bring various open source tools together and easily write to Dataset via the Docker Agent. 
If any data is sent to the console of a container, the dataset agent will pick it up. 
There is also more advaced persistence if you need to allow for spooling and backfilling of data and pushing to multiple dataset accounts. 


# Setup


## Pre Reqs

1. VM running Ubuntu 
- Create one in your cloud's UI or CLI 
- Or use one of the startup scripts
([Azure](https://github.com/jmorascalyr/Dataset-Syslog/blob/azure/az-vm-create.sh), [AWS](https://github.com/jmorascalyr/Dataset-Syslog/blob/main/ec2-startup.sh))


2. Docker on the VM 
- You can use the startup [script](https://github.com/jmorascalyr/Dataset-Syslog/blob/azure/host-startup.sh)


## VM 

### Setup VM for rSyslog
1. `git clone  https://github.com/scalyr/dataset-pipeline.git; cd dataset-pipeline.git`
2. open  docker-compose.yaml. `sudo vim docker-compose.yaml` . 
- add `https://agent.scalyr.com` to the SCALYR_SERVER field
- add your api key to the SCALYR_API_KEY field
3. `sudo docker-compose up -d`
4. Send messages to port 6514

### Setup VM for vector
1. `git clone  https://github.com/scalyr/dataset-pipeline.git; cd dataset-pipeline.git`
2. open  docker-compose.yaml. `sudo vim docker-compose.yaml` . 
- add `https://agent.scalyr.com` to the SCALYR_SERVER field
- add your api key to the SCALYR_API_KEY field
3. `sudo docker-compose up -d`
4. Send messages to port 515 
5. feel free to remove unnecessisary containers.

### Send Syslog Message
1. Make sure the ports 80 (agent proxy), 443 (agent proxy), 6514 (syslog only), 515 (vector syslog) are open in your security group in your cloud and on the Ubuntu firewall 
2. Send single message `nc -w0 -u my-ip-address port <<< "<134>Jul 26 00:00:54 1,2015/12/15 12:09:53,0003C102241,THREAT,url,8,2015/12/15 12:09:52,172.21.22.205,172.21.4.140,0.0.0.0,0.0.0.0,Admin_Inbound,,,ssl,vsys3,VAdmin-Building,VAdmin-ITConn,ethernet1/18,ethernet1/14,Syslog,2015/12/15 12:09:52,113357,1,4853,8080,0,0,0x0,tcp,alert,"secureinclude.ebaystatic.com/",(9999),auctions,informational,client-to-server"`
3. Add it as your endpoint address to start streaming data. example
<img width="1125" alt="image" src="https://user-images.githubusercontent.com/42879226/180902665-01d241b8-520f-4162-bde4-73a6bb189cd1.png">
 


### TLS Encryption. 
This uses several tools where tls can be configured. 

[RSyslog](https://www.rsyslog.com/doc/master/tutorials/tls.html)'s TLS functionality. 
1. `sudo vim ./config/rsyslog/rsyslog.conf`
2. Append this to the bottom of the file


```
# make gtls driver the default and set certificate files
global(
DefaultNetstreamDriver="gtls"
DefaultNetstreamDriverCAFile="/path/to/contrib/gnutls/ca.pem"
DefaultNetstreamDriverCertFile="/path/to/contrib/gnutls/cert.pem"
DefaultNetstreamDriverKeyFile="/path/to/contrib/gnutls/key.pem"
)

# load TCP listener
module(
load="imtcp"
StreamDriver.Name="gtls"
StreamDriver.Mode="1"
StreamDriver.Authmode="anon"
)

```

[Vector](https://vector.dev/docs/reference/configuration/sources/syslog/)

Transport Layer Security (TLS)
Vector uses OpenSSL for TLS protocols. You can adjust TLS behavior via the tls.* options.
Read more [here](https://vector.dev/docs/reference/configuration/sources/syslog/)

