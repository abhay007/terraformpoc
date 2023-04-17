#!/bin/bash
sudo su
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello Paymentology This from ABHAY SINGH" > /var/www/html/index.html