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

#Устанавливаем Docker
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

#Проверяем как встал Docker
sudo docker run hello-world

#Устанавливаем Portainer последней версии
sudo docker volume create portainer_data
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

#Проверяем как встал Portainer
docker ps

echo "Введите имя домена sugarsveta.ru, на котором ваш Nightscout будет доступен:"
read domain
echo "NS_DOMAIN=$domain" >> .env
echo

echo
echo "Enter you email (the one SSL certificate will be generated for):"
echo "Введите ваш email (на него будет зарегистрирован SSL-сертификат):"
read email
echo "NS_EMAIL=$email" >> .env
echo

curl https://raw.githubusercontent.com/mo211073bkp/test/main/docker-compose.yml --output docker-compose.yml
sudo docker-compose up -d

#Устанавливаем редактор Nano для возможности редактированя в будущем
apt install nano

echo "Ваш Nightscout доступен по адресу (запишите!):"
echo "domain: $domain"
