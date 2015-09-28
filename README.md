# timestamp
Test performance timestamp

Я проводив тест, а точніше виконував це тестове завдання:

how you would design a timestamp service (i.e. a web service that serves the epoch timestamp at the URL /timestamp)

Завдання було знайти найоптимальнішу модель, при якій виконання веб сервісу timestamp витримувало б якомога більшу кількість запитів. У веб браузері необхідно отримати стрічку з цифрами (наприклад 1443104667), які постійно змінюється - unix timestamp (https://shafiqissani.wordpress.com/2010/09/30/how-to-get-the-current-epoch-time-unix-timestamp/)

Для тестування навантаження використовувалася vegeta (https://github.com/tsenart/vegeta). 
vegeta v5.8.1

Тест виконувався на Ноутбуку з Linux Mint 17.1, на віртуальних машинах - virtualbox 4.3, Linux Ubuntu 14.04 x64 2 Gb оперативки, 2 ядра

Використані моделі:

1. apache2 - php
2. apache2 - mod_cgi - bash script
3. mginx - http_perl_module
4. nginx - php-fpm
5. nginx - uwsgi - Django (python script)

Як показано в табличці з порівнянням результатів, найбільш ефективно працювала модель mginx - http_perl_module. При 5 тис запитах в секунду вона забезпечила найкращий результат - 99.73%. Найгірший результат - 6.50% показала модель apache2 - mod_cgi - bash script.
Навіть при 25000 запитах в секунду mginx - http_perl_module забезпечила результат 12.58%, при тому, що вичерпалася вся оперативна пам'ять.

Вважаємо, що якщо до моделі nginx-perl додати ще HAProxy з кількома серверами + DNS RoundRobin то можна буде обробляти і більше запитів.
=======================================================================

Конфіги:

http://192.168.0.211:8080/time

nginx 1.4.6
uwsgi 2.0.11.1
django 1.8.4
python 3.4

uwsgi --socket mysite.sock --wsgi-file time.py

/etc/nginx/nginx.conf
/etc/nginx/sites-available/mysite_nginx.conf
/home/sergiy/uwsgi-tutorial/mysite/time.py
======================================================
http://192.168.0.212/cgi-bin/example-bash.sh

apache 2.4.7

/var/www/html/cgi-bin/example-bash.sh
/etc/apache2/sites-available/000-default.conf
========================================================
http://192.168.0.212:8080/time.php

FPM

nginx/1.4.6
PHP 5.5.9

/etc/nginx/sites-available/default
/usr/share/nginx/html/time.php

=====================================================
http://192.168.0.212/time.php

apache 2.4.7
PHP 5.5.9

/var/www/html/time.php

=====================================================
http://192.168.0.108/timestamp

nginx 1.9.4

/etc/nginx/nginx.conf
/usr/local/nginx/perl/lib/datetime.pl



vegeta v5.8.1

sudo echo "GET http://192.168.0.108/timestamp" | ./vegeta -cpus=2 attack -duration=60s -connections=10000 -rate 5000 -workers=10 | tee results.bin | ./vegeta report

Requests	[total, rate]			300000, 5000.02
Duration	[total, attack, wait]		1m0.004098744s, 59.999799897s, 4.298847ms
Latencies	[mean, 50, 95, 99, max]		27.386855ms, 5.124731ms, 82.688851ms, 387.187602ms, 2.572129999s
Bytes In	[total, mean]			2991860, 9.97
Bytes Out	[total, mean]			0, 0.00
Success		[ratio]				99.73%
Status Codes	[code:count]			200:299186  0:814  
Error Set:
Get http://192.168.0.108/timestamp: dial tcp 192.168.0.108:80: too many open files
