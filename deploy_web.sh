#!/bin/sh

# Install web server (Apache), PHP and minimum PHP extension requirements to run Laravel
sudo apt-get update && sudo apt-get install apache2 php libapache2-mod-php php-mbstring php-cli php-bcmath php-json php-xml php-zip php-pdo php-common php-tokenizer php-mysql -y

# Install composer (package dependencies manager)
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
sudo chmod +x /usr/bin/composer

# Apache virtualhost configuration for Laravel
sudo touch /etc/apache2/sites-available/laravel.conf
sudo chmod 777 -R /etc/apache2/sites-available/laravel.conf
sudo cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
        DocumentRoot /var/www/html/deploy-tps3r/public
        <Directory /var/www/html/deploy-tps3r>
                AllowOverride All
        </Directory>
</VirtualHost>
EOF

# Disable default virtualhost
sudo a2dissite 000-default
sudo a2ensite laravel
sudo a2enmod rewrite

# Restart Apache
sudo systemctl restart apache2

# Setup Laravel web
cd /var/www/html
sudo git clone https://github.com/fabianhkm/tps3r-coba.git
cd deploy-tps3r/
sudo composer install --no-interaction
sudo chmod 755 -R *
sudo chown www-data:www-data -R *
sudo chmod 777 -R storage
sudo cp .env.example .env
sudo php artisan key:generate

