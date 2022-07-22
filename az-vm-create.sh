export NAME=dsyslog
export OS=Canonical:UbuntuServer:18.04-LTS:18.04.201804262
export LOCATION=westus3
export VMUSERNAME=demouser
export VMPASSWORD=Foobar21!foobar21!
export STARTUP_SCRIPT=./host_startup.sh
export r=$RANDOM

echo Starting deployment $r with the following values \\n\
NAME=dsyslog \\n\
OS=UbuntuLTS \\n\
LOCATION=eastus \\n\
VMUSERNAME=Demouser \\n\
VMPASSWORD=Demopass \\n\
STARTUP_SCRIPT=host_startup.sh


r=$RANDOM
export RESOURCE_GROUP=${NAME}-rg-${r}
export SECURITY_GROUP=${NAME}-sg-${r}
export NSG_NAME=${NAME}-nsg-${r}
export NICNAME=${NAME}-nic-${r}
export VNET=${NAME}-vnet-${r}
export PUBIP=${NAME}-ip-pub-${r}
export VMNAME=${OS}-${r}
export SUBNETNAME=${NAME}-sn-${r}

echo Creating infra with the following \\n\
RESOURCE_GROUP=${RESOURCE_GROUP} \\n\
SECURITY_GROUP=${SECURITY_GROUP} \\n \
NSG_NAME=${NSG_NAME} \\n\
NICNAME=${NICNAME} \\n\
VNET=${VNET} \\n\
VMNAME=${VMNAME} \\n\
SUBNETNAME=${SUBNETNAME}


echo creating resource group ${RESOURCE_GROUP}
az group create -l $LOCATION -n $RESOURCE_GROUP

echo creating vnet:${VNET}
az network vnet create \
    --name ${VNET} \
    --resource-group ${RESOURCE_GROUP} \
    --location ${LOCATION} \
    --address-prefix 10.10.0.0/16

echo creating vnet:${VNET} subnet:${SUBNETNAME}
az network vnet subnet create \
    --address-prefix 10.10.20.0/24 \
    --name ${SUBNETNAME} \
    --resource-group ${RESOURCE_GROUP} \
    --vnet-name ${VNET}

echo creating public-ip ${PUBIP}
az network public-ip create \
    --name ${PUBIP} \
    --resource-group ${RESOURCE_GROUP} \
    --location ${LOCATION} \
    --allocation-method dynamic

echo creating NIC ${NICNAME}
az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${NICNAME} \
    --vnet-name ${VNET} \
    --subnet ${SUBNETNAME} \
    --public-ip-address ${PUBIP}

echo creating nsg ${NSG_NAME}
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --name $NSG_NAME

echo creating nsg rule http
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name http \
    --protocol tcp \
    --priority 1000 \
    --destination-port-range 80

echo creating nsg rule syslog udp
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name syslog_udp \
    --protocol udp \
    --priority 1001 \
    --destination-port-range 6514

echo creating nsg rule syslog tcp
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name syslog_tcp \
    --protocol tcp \
    --priority 1002 \
    --destination-port-range 6514

echo creating nsg rule syslog https
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name https \
    --protocol tcp \
    --priority 1003 \
    --destination-port-range 443

echo creating nsg rule syslog ssh
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name ssh \
    --protocol tcp \
    --priority 1004 \
    --destination-port-range 22


echo update nic
az network nic update \
    --resource-group $RESOURCE_GROUP \
    --name ${NICNAME} \
    --network-security-group $NSG_NAME


echo creating vm..................
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name ${NAME}-${r} \
  --image 'UbuntuLTS' \
  --admin-username "${VMUSERNAME}" \
  --admin-password "${VMPASSWORD}" \
  --generate-ssh-keys \
  --nics ${NICNAME} \
  --custom-data ${STARTUP_SCRIPT} 

