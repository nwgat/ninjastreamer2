echo
echo  "## nwgat.ninja ninjastreamer ##"
echo "https://nwgat.ninja"
echo ""

read -p "RTMP Password: " pw
read -p "Domain or IP: " iphost

sed -e "s/"iphost"/"$iphost"/g" html/index.html -i.bkp
sed -e "s/"pw"/"$pw"/g" conf/nginx.conf -i.bkp

# update & upgrade
apt-get update
apt-get upgrade -y

# remove nginx
apt-get remove nginx nginx-common nginx-full --purge -y

# install ffmpeg
apt-get install -y ffmpeg p7zip-full

# install nginx-rtmp
#wget -q https://awesome.nwgat.ninja/nginx-rtmp/nginx-common_1.10.1-0ubuntu1.2_all.deb 
#wget -q https://awesome.nwgat.ninja/nginx-rtmp/nginx-full_1.10.1-0ubuntu1.2_amd64.deb
#dpkg -i nginx-full_1.10.1-0ubuntu1.2_amd64.deb nginx-common_1.10.1-0ubuntu1.2_all.deb >> /dev/null
#apt-get install -f -y

# install nginx-rtmp 1.12
wget -q https://awesome.nwgat.ninja/nginx-rtmp/nginx-1.12.1/nginx-1.12.1.deb.7z
7z e nginx-1.12.1.deb.7z
dpkg -i nginx-full_1.12.1-0ubuntu2_amd64.deb nginx-common_1.12.1-0ubuntu2_all.deb libnginx-mod-*
apt-get install -f -y

# install nginx-rtmp-keyauth
cp nginx-rtmp-keyauth /usr/local/bin/nginx-rtmp-keyauth
chmod +x /usr/local/bin/nginx-rtmp-keyauth
echo $pw >> /etc/nginx/nginx-rtmp-keyauth.key

# required files
cp conf/nginx.conf /etc/nginx/
cp conf/nginx-rtmp-keyauth.service /etc/systemd/system/
cp -R html /var/www/

# setup systemd
systemctl daemon-reload
systemctl enable nginx nginx-rtmp-keyauth

systemctl start nginx 
sleep 5
systemctl start nginx-rtmp-keyauth

# firewalls
ufw allow 1935 >> /dev/null
ufw allow 8080 >> /dev/null
ufw allow 80 >> /dev/null

sleep 15
systemctl restart nginx nginx-rtmp-keyauth

echo ""
# Details
echo "Ninja Player & Details" http://$iphost
echo "RTMP Password:" $pw
echo ""
echo ""
