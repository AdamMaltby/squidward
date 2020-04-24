# Squidward

#This is the setup for an "on-a-stick" not in line, single NIC based
#Squid Proxy, limited security and lockdown so not massively secure,
#put together purely for testing purposes only. It by no means covers
#all possible site access requirements, intended for basic use only.
#Port 3128 is authenticated testing
#Port 3129 is unauthenticated testing

#Install httpd & Squid
dnf -y install squid httpd

#copy over squid config
sudo cp ./squid.conf /etc/squid/squid.conf

#setup the testbasic auth user and make squid the file owner
sudo htaccess -c /etc/squid/.squid_basic_auth_users squidward
sudo htaccess -c /etc/squid/.squid_basic_auth_users someuser
sudo chown squid /etc/squid/.squid_basic_auth_users

#Enable forwarding. We aren't setting up any ip tables etc as we are
#only using a single nic with forwarding mode.:
sudo sysctl -w net.ipv4.ip_forward=1

#Rotate.sh - move this file to /etc/squid/ - it controls the squid archiving of
#yesterdays logfile and renaming functions
cp ./rotate.sh /etc/squid/rotate.sh
sudo chmod +x /etc/squid/rotate.sh

#Add to crontab job to kick off the squid rotate at midnight for the rotate.sh
#Note squid will need permissions to the target copy location specified in
#the script
sudo crontab -u squid  0 0 * * * /etc/squid/rotate.sh

#config firewall & restart services
sudo firewall-cmd --add-port=3128/tcp --permanent
sudo firewall-cmd --add-port=3129/tcp --permanent
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo systemctl restart firewall
sudo systemctl restart network
sudo systemctl enable squid
sudo systemctl start squid

