sudo yum update -y
sudo yum install docker git -y
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo yum install python3-pip -y
sudo pip3 install docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo mkdir GitHub
cd GitHub
sudo git clone https://github.com/jmorascalyr/Dataset-Syslog.git
cd Dataset-Syslog
sudo git checkout proxy
sudo docker-compose up -d
