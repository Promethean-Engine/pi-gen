#!/bin/bash -e

systemctl unmask hostapd
systemctl enable hostapd

echo "interface wlan0" >> /etc/dhcpcd.conf
echo "  static ip_address=192.168.1.1/24" >> /etc/dhcpcd.conf
echo "  nohook wpa_supplicant" >> /etc/dhcpcd.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/routed-ap.conf

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
netfilter-persistent save

mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

echo "interface=wlan0" >> /etc/dnsmasq.conf
echo "dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h" >> /etc/dnsmasq.conf
echo "domain=wlan" >> /etc/dnsmasq.conf
echo "address=/gw.wlan/192.168.4.1" >> /etc/dnsmasq.conf
rfkill unblock wlan

echo "country_code=US" >> /etc/hostapd/hostapd.conf
echo "interface=wlan0" >> /etc/hostapd/hostapd.conf
echo "ssid=FennelRoot" >> /etc/hostapd/hostapd.conf
echo "hw_mode=g" >> /etc/hostapd/hostapd.conf
echo "channel=7" >> /etc/hostapd/hostapd.conf
echo "macaddr_acl=0" >> /etc/hostapd/hostapd.conf
echo "auth_algs=1" >> /etc/hostapd/hostapd.conf
echo "ignore_broadcast_ssid=0" >> /etc/hostapd/hostapd.conf
echo "wpa=2" >> /etc/hostapd/hostapd.conf
echo "wpa_passphrase=Yggdrasil" >> /etc/hostapd/hostapd.conf
echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd/hostapd.conf
echo "wpa_pairwise=TKIP" >> /etc/hostapd/hostapd.conf
echo "rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf