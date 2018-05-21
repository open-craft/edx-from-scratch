#!/usr/bin/env bash

set -e

if ! getent hosts platform; then
  echo -e "192.168.33.10\tplatform" >> /etc/hosts
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y elasticsearch memcached mongodb-server mysql-server redis-server htop
apt-get clean

sed -i '/bind 127\.0\.0\.1/d' /etc/redis/redis.conf
sed -i '/bind-address/d' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/.*bind_ip.*/bind_ip = 0.0.0.0/' /etc/mongodb.conf
sed -i '/-l 127\.0\.0\.1/d' /etc/memcached.conf
sed -i 's/#START_DAEMON/START_DAEMON/' /etc/default/elasticsearch
for s in elasticsearch redis-server memcached mongodb mysql; do
    service ${s} restart
done

until mysql -se "SELECT 1" &> /dev/null
do
  printf "Waiting for MySQL..."
  sleep 1
done

mysql < ~vagrant/edx-from-scratch/mysql.sql
mongo < ~vagrant/edx-from-scratch/mongo.js
