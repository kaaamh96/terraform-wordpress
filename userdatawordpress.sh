#!/bin/bash
set -eux

# Update packages
dnf update -y

# Install Apache
dnf install -y httpd

# Install PHP
dnf install -y php php-mysqlnd php-fpm php-json php-gd php-mbstring php-xml php-curl php-zip

# Install MariaDB
dnf install -y mariadb105-server

# Enable and start services
systemctl enable httpd
systemctl enable mariadb

systemctl start httpd
systemctl start mariadb

# Create WordPress database
mysql <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'Password123!';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

# Copy files
cp -r wordpress/* /var/www/html/

# Configure WordPress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wpuser/" /var/www/html/wp-config.php
sed -i "s/password_here/Password123!/" /var/www/html/wp-config.php
sed -i "s/localhost/localhost/" /var/www/html/wp-config.php

# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Restart Apache
systemctl restart httpd