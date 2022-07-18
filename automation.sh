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

filename="/tmp/${myname}-httpd-logs-${timestamp}.tar"
file_size=$(du -sh $filename | awk '{print $1}')

cat /var/www/html/inventory.html
if [ $? -eq 1 ]; then
        touch inventory.html
        echo "Log Type          Time Created            Type            Size" > /var/www/html/inventory.html
        echo "httpd-logs                ${timestamp}            tar             ${file_size}" >> /var/www/html/inventory.html
else
        echo "httpd-logs                ${timestamp}            tar             ${file_size}" >> /var/www/html/inventory.html
fi


cat /etc/cron.d/automation
if [ $? -eq 1 ]; then
        echo "File does not exist"
        touch automation
        echo "PATH=/root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "0 1 * * *         root            /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
fi
