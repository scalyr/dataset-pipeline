# Dataset-Syslog
Rsyslog Dataset Agent and Loadbalancer


# Setup


## Pre Reqs

1. VM running Ubuntu 
- Create one in your cloud's UI or CLI 
- Or use one of the startup scripts
([Azure](https://github.com/jmorascalyr/Dataset-Syslog/blob/azure/az-vm-create.sh))


2. Docker on the VM 
- You can use the startup [script](https://github.com/jmorascalyr/Dataset-Syslog/blob/azure/host-startup.sh)


## VM 

### Setup VM for Syslog
1. `git clone  https://github.com/jmorascalyr/Dataset-Syslog.git; cd Dataset-Syslog.git`
2. open  docker-compose.yaml. `sudo vim docker-compose.yaml` . 
- add `https://agent.scalyr.com` to the SCALYR_SERVER field
- add your api key to the SCALYR_API_KEY field
3. `sudo docker-compose up -d`

### Send Syslog Message
1. Make sure the ports 80 (agent proxy), 443 (agent proxy), 6514 (syslog only) are open in your security group in your cloud and on the Ubuntu firewall 
2. Send single message `nc -w0 -u my-ip-address-to-my-vm 6514 <<< "<134>Jul 26 00:00:54 1,2015/12/15 12:09:53,0003C102241,THREAT,url,8,2015/12/15 12:09:52,172.21.22.205,172.21.4.140,0.0.0.0,0.0.0.0,Admin_Inbound,,,ssl,vsys3,VAdmin-Building,VAdmin-ITConn,ethernet1/18,ethernet1/14,Syslog,2015/12/15 12:09:52,113357,1,4853,8080,0,0,0x0,tcp,alert,"secureinclude.ebaystatic.com/",(9999),auctions,informational,client-to-server"`
3. Add it as your endpoint address


### TLS Encryption. 
This uses [RSyslog](https://www.rsyslog.com/doc/master/tutorials/tls.html)'s TLS functionality. 
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




