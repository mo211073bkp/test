# Информация для посвященных:
# Установка Nightscout & Portainer на хосте jino.ru.
1. Вам нужно зарегистрировать свой VPS на jino.ru и оплатить свой хостинг.
2. Через меню "Домен" нужно зарегистрировать свой домен и прbвязать к своей учетной записи.
-Когда всё получится - не забываем включить там же галочку "Всегда использовать только HTTPS"
-Заодно стоит убедиться, что не включена переадресация. Идём в домен /основные настройки / показать дополнительные настройки.
Там "префикс www " выставить в "не перенаправлять"
3. Вам нужно создать свой сервер: выбираем тариф "Альфа"->тип сервера "SSD+SSH", далее выбираем:
-Образ Ubuntu 20.04 LTS; -Хранение и обработка данных MongoDB CE 6.0; -Другое Docker CE. Выбираем название сервера и нажимаем создать.

# После создания сервера открываем консоль.

1. Заходим в консоль своей VPS,
2. Копируем эту строку: `bash <(wget -qO- https://raw.githubusercontent.com/mo211073bkp/test/main/ns-setup.sh)` , вставляем и нажимаем Enter.
3. По окончанию установки, для работы с Portainer нужно пробросить 9443 порт (управление->перенаравление портов->создать перенаправление, вводим 9443 порт и комментарий Portainer), нажимаем добавить.
4. Всё, может открывать свой найтскаут, а переменные править в Portainer.
5. Для миграции соей БД с Atlas на Ваш персональный сервер в консоли набираем docker exec -it mongo /usr/bin/mongodump --uri="", где в кавычках стоит ГКД Вашей БД.;
затем docker exec -it mongo /usr/bin/mongorestore --db ns dump/mycgm (mycgm - это имя базы из MongoDB Atlas)

