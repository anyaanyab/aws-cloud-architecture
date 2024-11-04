#!/bin/bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<html><h1>Webpage for the <strong>Cloud Programming</strong> project at IU.</h1></html>" > /var/www/html/index.html