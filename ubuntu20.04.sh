echo updating apt
sudo apt update
echo install certs https curl git and others
sudo apt install git apt-transport-https ca-certificates curl software-properties-common -y
echo downloading docker from docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo adding repo
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
echo apt-cache policy update
apt-cache policy docker-ce
echo install docker
sudo apt install docker-ce -y
echo start docker
sudo systemctl is-active --quiet docker
echo view docker processes
sudo docker ps
echo dowloading docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo permissions of docker compose file
sudo chmod +x /usr/local/bin/docker-compose
echo docker compose version
sudo docker-compose --version
echo creating directories
sudo mkdir ~/GitHub
echo changing directories
cd ~/GitHub
echo download appliance
sudo git clone https://github.com/scalyr/dataset-pipeline.git
echo moving into new appliance directory
cd dataset-pipeline

echo continuing to setup
read -p "Do you want to continue to setting up dataset? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo touch ~/GitHub/dataset-pipeline/.env
    sudo chmod -R a+rwx ~/GitHub/dataset-pipeline/.env
    echo What is your api key?
    read -p "SCALYR_API_KEY="
    sudo echo SCALYR_API_KEY=$REPLY >> ~/GitHub/dataset-pipeline/.env
    sudo echo DATASET_API_KEY=$REPLY >> ~/GitHub/dataset-pipeline/.env
    export SCALYR_API_KEY=$REPLY
    export DATASET_API_KEY=$REPLY
    echo added to end of file
    cat ~/GitHub/dataset-pipeline/.env
    read -p "is your server something different than https://app.scalyr.com? (y/n)" -n 1 -r
    if [[ $REPLY =~ ^[yY]$ ]]
    then
        echo What is your Dataset Server?
        read -p "SCALYR_SERVER="
        echo
        echo SCALYR_SERVER=$REPLY >> ~/GitHub/dataset-pipeline/.env
        echo DATASET_SERVER=$REPLY >> ~/GitHub/dataset-pipeline/.env
	export DATASET_SERVER=$REPLY
	export SCALYR_SERVER=$REPLY
	echo added to end of file
	cat ~/GitHub/dataset-pipeline/.env
    else
        echo adding default to end of file
	echo
	echo SCALYR_SERVER=https://app.scalyr.com >> ~/GitHub/dataset-pipeline/.env
	echo DATASET_SERVER=https://app.scalyr.com >> ~/GitHub/dataset-pipeline/.env
	export DATASET_SERVER=https://app.scalyr.com
	export SCALYR_SERVER=https://app.scalyr.com
	cat ~/GitHub/dataset-pipeline/.env
    fi

fi

echo do you want to start the docker container? sudo docker-compose up -d
read -p "(Y/N).... " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo
	echo navigating to directory
	cd ~/GitHub/dataset-pipeline
	echo starting docker
	sudo docker-compose up -d
	sudo docker ps
else
	echo done.
	echo To start the contaner navigate to ~/GitHub/dataset-pipeline
        echo make sure to add an api key to ~/GitHub/dataset-pipeline/.env
	echo make sure there is a SCALYR_SERVER and SCALYR_API_KEY
	echo run sudo docker-compose up -d
fi
