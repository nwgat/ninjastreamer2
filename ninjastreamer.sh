echo
echo  "## nwgat.ninja ninjastreamer ##"
echo "https://nwgat.ninja"
echo ""
#read -p "RTMP Password: " pw

# remove nginx
apt-get remove nginx --purge -y

# required files
cp conf/nginx.conf /etc/nginx/
cp conf/nginx-rtmp-keyauth.service /etc/systemd/system/
cp -r html /var/www/


# install nginx-rtmp
wget https://awesome.nwgat.ninja/nginx-rtmp/nginx-common_1.10.1-0ubuntu1.2_all.deb
wget https://awesome.nwgat.ninja/nginx-rtmp/nginx-full_1.10.1-0ubuntu1.2_amd64.deb
dpkg -i nginx-full_1.10.1-0ubuntu1.2_amd64.deb nginx-common_1.10.1-0ubuntu1.2_all.deb
apt-get install -f

# install nginx-rtmp-keyauth
cp nginx-rtmp-keyauth /usr/local/bin/nginx-rtmp-keyauth
echo anime >> /etc/nginx-rtmp-keyauth.key
systemctl daemon-reload
systemctl enable nginx nginx-rtmp-keyauth

systemctl start nginx nginx-rtmp-keyauth
systemctl status nginx  nginx-rtmp-keyauth

#firewalls
ufw allow 1935
ufw allow 8080
ufw allow 80

# Details
#echo "Ninja Player" http://$ip
#echo "RTMP" rtmp://$ip:1935/in
#echo "RTMP Password:" $pw
