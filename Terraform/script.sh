sudo wget https://wordpress.org/latest.zip
sudo apt-get install unzip -y
sudo unzip latest.zip
sudo apt-get install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
