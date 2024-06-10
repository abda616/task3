#!/bin/bash
yum update -y
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

yum install -y amazon-cloudwatch-agent amazon-efs-utils nfs-utils
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux
yum install -y httpd php php-mysqlnd php-json

cd ~
wget https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
yum localinstall -y mysql84-community-release-el9-1.noarch.rpm
yum install -y mysql-community-server
rm -rf mysql84-community-release-el9-1.noarch.rpm
systemctl start httpd mysqld
yum update -y


cd /var/www/html/
wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo mv wordpress/* .
sudo chown -R apache:apache /var/www/html/
sudo rm -rf wordpress latest.tar.gz wp-config-sample.php  wp-content

wget https://raw.githubusercontent.com/abda616/task3/main/wp-config.php
export DB_HOST=$(aws ssm get-parameters --names /wordpress/DB_HOST --with-decryption --query 'Parameters[0].Value' | sed 's/\"//g')
export DB_NAME=$(aws ssm get-parameters --names /wordpress/DB_NAME --with-decryption --query 'Parameters[0].Value' | sed 's/\"//g')
export DB_PASSWORD=$(aws ssm get-parameters --names /wordpress/DB_PASSWORD --with-decryption --query 'Parameters[0].Value' | sed 's/\"//g')
export DB_USER=$(aws ssm get-parameters --names /wordpress/DB_USER --with-decryption --query 'Parameters[0].Value' | sed 's/\"//g')
export table_prefix="\$table_prefix"
envsubst < wp-config.php > tem.php
mv -f tem.php wp-config.php

mkdir -p /var/www/html/wp-content
export EFS_FILE=$(aws ssm get-parameters --names /wordpress/efs --with-decryption --query 'Parameters[0].Value' | sed 's/\"//g')
echo ${EFS_FILE}:/ /var/www/html/wp-content efs _netdev,tls 0 0 >> /etc/fstab
sudo mount -t efs -o tls $EFS_FILE:/ /var/www/html/wp-content

systemctl restart mysqld httpd
systemctl enable mysqld httpd 