#!/bin/bash
#init_os.sh
echo -n "Enter your hostname:"
read hostname
echo "$hostname" > /etc/hostname
echo "hostname is set to $hostname"

echo -n "Enter your ip address: 192.168.137."
read ipAddr
echo "ip address is set to 192.168.137.$ipAddr"

echo -n "Enter your mac address 00:0A:35:00:"
read macAddr
echo "mac address is set to 00:0A:35:00:$macAddr"

sed -i "s/iface eth0 inet dhcp/iface eth0 inet static/g" /etc/network/interfaces
sed -i "/iface eth0 inet static/a netmask 255.255.255.0" /etc/network/interfaces
sed -i "/iface eth0 inet static/a gateway 192.168.137.1" /etc/network/interfaces
sed -i "/iface eth0 inet static/a hwaddress ether 00:0A:35:00:$macAddr" /etc/network/interfaces
sed -i "/iface eth0 inet static/a address 192.168.137.$ipAddr" /etc/network/interfaces
sed -i "s/iface eth1 inet dhcp//g" /etc/network/interfaces

echo "###### Restart Network #######"
sudo /etc/init.d/networking restart

echo "###### Setting startup script #######"
mkdir -p /etc/resolvconf/resolv.conf.d/ ; touch /etc/resolvconf/resolv.conf.d/head
echo -e "domain mshome.net\nnameserver 192.168.137.1\nnameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
cat /etc/resolvconf/resolv.conf.d/head
touch /etc/init.d/startup.sh
echo -e "cp /etc/resolvconf/resolv.conf.d/head /etc/resolv.conf\necho \"/usr/local/lib\" >> /etc/ld.so.conf\nsudo ldconfig\ninsmod /lib/modules/5.4.0-xilinx-v2020.1/extra/dma-proxy.ko" >> /etc/init.d/startup.sh
cat /etc/init.d/startup.sh
sudo chmod +x /etc/init.d/startup.sh
ln -s /etc/init.d/startup.sh /etc/rcS.d/S99startup.sh 
ls /etc/rcS.d/ | grep S99 # check

echo -e "LD_LIBRARY_PATH=\"/lib:/usr/lib:/usr/local/lib\"\nexport PKG_CONFIG_PATH=\"/usr/local/lib/pkgconfig:\$PKG_CONFIG_PATH\"" >> /etc/profile 
source /etc/profile

echo "###### Reboot #######"
sudo reboot



