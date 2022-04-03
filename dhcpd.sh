#!/bin/bash
#exercici 2 dhcpd.sh
#Pol Sanz
#
clear

DATA=$(date +20%y%m%d)
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$DATA

echo "authoritative;" > /etc/dhcp/dhcpd.conf
echo "ddns-update-style none;" >> /etc/dhcp/dhcpd.conf

echo "escriu el domini"
read domini
echo 'option domain-name "$domini";' >> /etc/dhcp/dhcpd.conf

echo "escriu l'adreça ip del DNS"
read dns
echo "option domain-name-servers $dns;" >> /etc/dhcp/dhcpd.conf

echo "escriu l'adreça ip del router per defecte"
read router
echo "option routers $router;" >> /etc/dhcp/dhcpd.conf

echo "escriu el valor del temps de leasing per defecte"
read lease_def
echo "default-lease-time $lease_def;" >> /etc/dhcp/dhcpd.conf

echo "escriu el valor del temps de leasing màxim"
read lease_max
echo "max-lease-time $lease_max;" >> /etc/dhcp/dhcpd.conf

echo "escriu l'adreça ip de la subxarxa"
read subxarxa

echo "escriu la màscara de la subxarxa"
read masc
echo "subnet $subxarxa netmask $masc {" >> /etc/dhcp/dhcpd.conf

echo "escriu la primera adreça IP del marge d'adreces ip"
read primeraIP

echo "escriu l'ultima adreça ip del marge d'adreces ip"
read ultimaIP
echo " range $primeraIP $ultimaIP;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf


sudo systemctl restart isc-dhcp-server

exit 0
