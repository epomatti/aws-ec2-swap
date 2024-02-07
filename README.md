# AWS EC2 memory swap

Swap commands are scripted in the `userdata` file following instructions from this [article][1].

Create the `.auto.tfvars` file:

```terraform
aws_region    = "us-east-2"
ami           = "ami-045909c05cb423e93" # Ubuntu 22.04 arm64
instance_type = "t4g.nano"
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Verify that the swap is working, such as by using SSM Patch.

```sh
free -h
lsblk
```

https://serverfault.com/questions/218750/why-dont-ec2-ubuntu-images-have-swap

sysctl -w vm.swappiness=20
cat /proc/sys/vm/swappiness

https://askubuntu.com/questions/103915/how-do-i-configure-swappiness
https://askubuntu.com/questions/192304/changing-swappiness-in-sysctl-conf-doesnt-work-for-me



curl -L https://github.com/epomatti/stressbox/archive/refs/tags/v0.1.4.tar.gz -o stressbox.tar.gz
tar -xzf stressbox.tar.gz



## Command reference

```sh
# Confirm you can use swap
lsblk -f

# Determine the amount of space needed
# If under 1GB RAM, use an equal amount. If more than 1GB RAM, use square root at a minimum
free -hm

# swap file = block size (bs) * number of blocks (count)
dd if=/dev/zero of=/swapfile bs=128M count=4

# update the read and write permissions for the swap file
chmod 600 /swapfile

# set up a Linux swap area
mkswap /swapfile
swapon /swapfile

# verify that the procedure was successful
swapon -s

# make the swap file usable by the kernel on the next reboot
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
```

---

### Clean-up

```sh
terraform destroy -auto-approve
```


[1]: https://repost.aws/knowledge-center/ec2-memory-swap-file
