#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y

### CloudWatch Agent ###
platform="arm64"
region="us-east-2"
wget https://amazoncloudwatch-agent-$region.s3.$region.amazonaws.com/ubuntu/$platform/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
ssmParameterName=AmazonCloudWatch-linux-Swap
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:$ssmParameterName -s

### Install more services to consume memory ###

# Nginx
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# MySQL
apt install -y mysql-server
systemctl enable mysql.service
systemctl start mysql.service

# CodeDeploy
apt install -y ruby-full
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto


reboot
