#!/bin/bash
sudo su -

echo "Enter port:"
read setupPort

apt update && apt upgrade -y
apt install git fail2ban nginx nodejs npm ufw emacs -y
add-apt-repository ppa:certbot/certbot
apt-get install python-certbot-nginx
npm i -g yarn gatsby-cli nodemon pm2

echo "alias e='emacs -nw'" >> ~/.bashrc
touch ~/clean.sh
echo "#!/bin/bash" > ~/clean.sh
echo 'find . \( -name "#*#" -o -name "*~" \) -delete' >> ~/clean.sh
chmod +x ~/clean.sh
echo "alias c='~/clean.sh'" >> ~/.bashrc
source ~/.bashrc

echo "Please find #Port 22: uncomment and change 22 with your port"
read -p "Press enter to continue"
e /etc/ssh/sshd_config

ufw disable && echo "y" | sudo ufw enable
ufw default deny outgoing
ufw default deny incoming
ufw allow ${setupPort}/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw disable && echo "y" | sudo ufw enable
ufw allow 'Nginx Full'

systemctl enable nginx
systemctl restart nginx
systemctl restart sshd

echo "Enter new username:"
read newUsername

adduser ${newUsername}
usermod -aG sudo ${newUsername}

echo "Successfull setup on port: ${setupPort} for user ${newUsername}"
echo "You should now delete the user you're currently logged in"
