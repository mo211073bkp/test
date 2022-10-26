#!/bin/sh

sudo apt-get update

sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo docker run hello-world

sudo docker volume create portainer_data
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
docker ps

echo Введите имя домена sugarsveta.ru, на котором ваш Nightscout будет доступен:
read domain
echo "NS_DOMAIN=$domain" >> .env
echo

curl https://raw.githubusercontent.com/mo211073bkp/test/main/docker-compose.yml --output docker-compose.yml
sudo docker-compose up -d

echo "Ваш Nightscout доступен по адресу (запишите!):"
echo "domain: $domain"
