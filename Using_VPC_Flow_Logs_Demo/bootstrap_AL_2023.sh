#!/bin/bash	
dnf update -y
dnf install httpd -y
systemctl enable httpd
systemctl start httpd
