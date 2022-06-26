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
        DocumentRoot /var/www/html/Database_Seeder_Factory_Laravel/public
        <Directory /var/www/html/Database_Seeder_Factory_Laravel>
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
sudo git clone https://github.com/AfiNaufal97/Database_Seeder_Factory_Laravel.git
cd Database_Seeder_Factory_Laravel/
sudo composer install --no-interaction
sudo chmod 755 -R *
sudo chown www-data:www-data -R *
sudo chmod 777 -R storage
sudo cp .env.example .env
sudo php artisan key:generate

