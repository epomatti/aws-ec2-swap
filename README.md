# aws-ec2-swap

Command reference:

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

Commands for partitions:

```sh
free -h
lsblk
```

Source:

- [How do I allocate memory to work as swap space in an Amazon EC2 instance by using a swap file](https://youtu.be/uAr_EIlTIxs)
- [How do I create a swap partition for my EC2 instance](https://youtu.be/oHW0quS4pV4)
