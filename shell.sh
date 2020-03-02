#!/bin/bash
echo -n "Masukkan domain anda lalu tekan [ENTER] (dapat juga menggunakan localhost): "
read domain

# set repository
sudo tee /etc/apt/sources.list << !
deb http://repo.apps.cs.ipb.ac.id/ubuntu bionic          main restricted universe multiverse
deb http://repo.apps.cs.ipb.ac.id/ubuntu bionic-updates  main restricted universe multiverse
deb http://repo.apps.cs.ipb.ac.id/ubuntu bionic-security main restricted universe multiverse
! -y

#Install Apache, PHP, MySQL
sudo apt update -y
sudo apt install apache2 php mysql-server -y
sudo apt install php-mysql php-gd php-mbstring php-xml php-curl -y
sudo service apache2 restart -y

DB_ROOT_PASS='root'

# Buat database

DB_Name='lychee_db'
DB_User='lychee_user'
DB_Pass='password'

#Create database with DB_Name, DB_User, and DB_Pass
mysql -u root --password=$DB_ROOT_PASS <<MYSQL_SCRIPT
CREATE DATABASE $DB_Name CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$DB_User'@'localhost' IDENTIFIED BY '$DB_Pass';
GRANT ALL PRIVILEGES ON $DB_Name.* TO '$DB_User'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user created."
echo "Database Name	:   $DB_Name"
echo "Database Username	:   $DB_User"
echo "Database Password :   $DB_Pass"

# Install Lychee
cd /var/www/html/
sudo chmod 777 /var/www/html/
git clone https://github.com/electerious/Lychee.git
cd /var/www/html/Lychee
chmod -R 750 uploads/ data/

# Restart Apache
sudo service apache2 restart
echo "PrestaShop Successfully Installed"
echo "Open your $domain or http://localhost/prestashop"
echo "Continue installation in your browser"
echo "Save this information"
echo "MYSQL Root Password : $DB_ROOT_PASS"
echo "Database Name	:   $DB_Name"
echo "Database Username	:   $DB_User"
echo "Database Password :   $DB_Pass"
