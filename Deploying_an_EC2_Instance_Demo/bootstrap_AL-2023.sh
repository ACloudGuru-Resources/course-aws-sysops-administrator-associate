#!/bin/bash	
dnf update -y
dnf install httpd -y
systemctl enable httpd
systemscl start httpd
