#!/bin/sh
GREEN='\033[0;32m'
NORMAL='\033[0m'
YELLOW='\033[0;33m'

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

echo Итак, немного настроек
echo

while [[ ! "$domain" =~ ^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$ ]]; do
  echo "Введите имя домена, на котором ваш Nightscout будет доступен:"
  read domain
done

echo "Ваш Nightscout будет зпрегистрирован по адресу (проверьте!):"
echo "domain: $domain"
read -p "Доменное имя введено без ошибок? (Нажмите [y/Y] для выполнения)"$'\n'  -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo -e "$GREEN Запускаем скрипт установки $NORMAL"
else
echo -e "$YELLOW ОШИБКА!!! $NORMAL" 
echo -e "$YELLOW Введите ПРАВИЛЬНО имя домена который Вы зарегистрировали $NORMAL"
echo -e "$YELLOW (типа sugarsveta.ru), на котором ваш Nightscout будет доступен: $NORMAL"
read domain
echo "NS_DOMAIN=$domain"
echo -e "$GREEN Ваш Nightscout будет зпрегистрирован по адресу: $NORMAL"
echo "domain: $domain"
fi
echo "NS_DOMAIN=$domain" >> .env

secret=$(cat /proc/sys/kernel/random/uuid)
echo "NS_SECRET=$secret" >> .env

curl https://raw.githubusercontent.com/justmara/ns-setup/jino/docker-compose.yml --output docker-compose.yml

sudo docker compose up -d

echo "Ваш секретный ключ для доступа к Nightscout (запишите!):"
echo "secret: $secret"
echo "domain: $domain"
