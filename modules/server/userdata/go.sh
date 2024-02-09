#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y

apt install -y unzip

### CloudWatch Agent ###
platform="arm64"
region="us-east-2"
wget https://amazoncloudwatch-agent-$region.s3.$region.amazonaws.com/ubuntu/$platform/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
ssmParameterName=AmazonCloudWatch-linux-Swap
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:$ssmParameterName -s


### Go ###
goVersion="1.22.0"
curl -L https://go.dev/dl/go$goVersion.linux-arm64.tar.gz -o go.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile


### Swap ###
swapiness=20
sysctl -w vm.swappiness=$swapiness
echo "vm.swappiness=$swapiness" >> /etc/sysctl.conf

# swap
swapfile="/swapfile"
dd if=/dev/zero of=$swapfile bs=64M count=8
chmod 600 $swapfile
mkswap $swapfile
swapon $swapfile
echo "$swapfile swap swap defaults 0 0" >> /etc/fstab


reboot
