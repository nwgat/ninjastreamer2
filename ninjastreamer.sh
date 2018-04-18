echo
echo  "## nwgat.ninja ninjastreamer ##"
echo "https://nwgat.ninja"
echo ""

read -p "RTMP Password: " pw
read -p "Domain or IP: " ip

sed -i -e 's/$ip/ip/g' html/index.html

# remove nginx
apt-get remove nginx --purge -y

# required files
cp conf/nginx.conf /etc/nginx/
cp conf/nginx-rtmp-keyauth.service /etc/systemd/system/
cp -r html/* /var/www/html/

# install nginx-rtmp
wget https://awesome.nwgat.ninja/nginx-rtmp/nginx-common_1.10.1-0ubuntu1.2_all.deb
wget https://awesome.nwgat.ninja/nginx-rtmp/nginx-full_1.10.1-0ubuntu1.2_amd64.deb
dpkg -i nginx-full_1.10.1-0ubuntu1.2_amd64.deb nginx-common_1.10.1-0ubuntu1.2_all.deb
apt-get install -f -y

# install nginx-rtmp-keyauth
cp nginx-rtmp-keyauth /usr/local/bin/nginx-rtmp-keyauth
chmod +x /usr/local/bin/nginx-rtmp-keyauth
echo $pw >> /etc/nginx-rtmp-keyauth.key

# setup systemd
systemctl daemon-reload
systemctl enable nginx nginx-rtmp-keyauth

systemctl start nginx nginx-rtmp-keyauth
systemctl status nginx  nginx-rtmp-keyauth

#firewalls
ufw allow 1935
ufw allow 8080
ufw allow 80

# Details
echo "Ninja Player & Details" http://$ip
echo "RTMP Password:" $pw
