sudo wget https://wordpress.org/latest.zip
sudo apt-get install unzip -y
sudo unzip latest.zip
sudo apt-get install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
