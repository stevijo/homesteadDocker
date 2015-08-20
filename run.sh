#!/bin/bash

echo "starting nginx"
service nginx start

echo "starting php5-fpm"
service php5-fpm start

echo "starting supervisor"
service supervisor start

echo "starting mysql"
service mysql start

echo "starting mongo"
/usr/bin/mongod --fork --logpath /var/log/mongodb.log --config /etc/mongod.conf

#create admin account to memcached using SASL
if [ ! -f /.memcached_admin_created ]; then
	/create_memcached_admin_user.sh
fi

echo "starting memcached"
service memcached start

echo "starting beanstalk"
/etc/init.d/beanstalkd start

echo "starting redis server"
redis-server /etc/redis/redis.conf

echo "starting ssh (ssh is the only service keeping this container alive)"
exec /usr/sbin/sshd -D
