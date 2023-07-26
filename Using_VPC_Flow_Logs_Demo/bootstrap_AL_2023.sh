#!/bin/bash	
dnf update -y
dnf install httpd -y
systemctl start httpd
systemctl enable httpd
