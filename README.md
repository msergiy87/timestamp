#Timestamp performance test  

I performed test objectives:
"How you would design a timestamp service (i.e. a web service that serves the epoch timestamp at the URL /timestamp)".

The test was to find the most appropriate model in wich the execution of web service timestamp could handle the largest possible number of queries. The web browser should show a line with numbers (eg 1443104667), which is constantly changing - unix timestamp (https://shafiqissani.wordpress.com/2010/09/30/how-to-get-the-current-epoch-time-unix-timestamp/)

Equipments:

vegetа for test performance (https://github.com/tsenart/vegeta).
Laptop with Linux Mint 17.1, with virtualbox 4.3, Linux Ubuntu 14.04 x64 on VHS, 2 Gb RAM, 2 CPU

Used models:

1. apache2 - php
2. apache2 - mod_cgi - bash script
3. nginx - http_perl_module
4. nginx - php-fpm
5. nginx - uwsgi - Django (python script)


As shown in the table of comparing results, the most efficient working model is nginx - http_perl_module. At 5000 requests per second it has provided the best result - 99.73% (percentage of successfull requests). The worst rezalt - 6.50% showed the model apache2 - mod_cgi - bash script. Even with 25000 quires nginx - http_perl_module provided result 12.58%.

We believe that if the model nginx-perl add Haprxy with multiple servers + DNS RoundRobin it can handle more requests.



Configuration files:

1. apache2 - php

http://192.168.0.212/time.php

apache 2.4.7
PHP 5.5.9

/var/www/html/time.php



2. apache2 - mod_cgi - bash script

http://192.168.0.212/cgi-bin/example-bash.sh

apache 2.4.7

/var/www/html/cgi-bin/example-bash.sh
/etc/apache2/sites-available/000-default.conf



3. nginx - http_perl_module

http://192.168.0.108/timestamp

nginx 1.9.4

/etc/nginx/nginx.conf
/usr/local/nginx/perl/lib/datetime.pl



4. nginx - php-fpm

http://192.168.0.212:8080/time.php

nginx/1.4.6
PHP 5.5.9

/etc/nginx/sites-available/default
/usr/share/nginx/html/time.php



5. nginx - uwsgi - Django (python script)

http://192.168.0.211:8080/time

nginx 1.4.6
uwsgi 2.0.11.1
django 1.8.4
python 3.4

uwsgi --socket mysite.sock --wsgi-file time.py

/etc/nginx/nginx.conf
/etc/nginx/sites-available/mysite_nginx.conf
/home/sergiy/uwsgi-tutorial/mysite/time.py



vegeta v5.8.1

sudo echo "GET http://192.168.0.108/timestamp" | ./vegeta -cpus=2 attack -duration=60s -connections=10000 -rate    5000 -workers=10 | tee results.bin | ./vegeta report

    Requests    	[total, rate]			300000, 5000.02
    Duration	    [total, attack, wait]		1m0.004098744s, 59.999799897s, 4.298847ms
    Latencies	    [mean, 50, 95, 99, max]		27.386855ms, 5.124731ms, 82.688851ms, 387.187602ms, 2.572129999s
    Bytes In    	[total, mean]			2991860, 9.97
    Bytes Out   	[total, mean]			0, 0.00
    Success	    	[ratio]				99.73%
    Status Codes	[code:count]			200:299186  0:814  
    Error Set:
    Get http://192.168.0.108/timestamp: dial tcp 192.168.0.108:80: too many open files
