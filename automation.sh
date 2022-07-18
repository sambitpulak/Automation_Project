#!/bin/bash

myname="sambit"
timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket="upgrad-sambit"

sudo apt update -y

dpkg-query -l apache2
if [ $? -eq 1 ]; then
	sudo apt-get install apache2
else
	echo "Package is installed"
fi

systemctl start apache2
systemctl enable apache2
systemctl status apache2

tar cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
