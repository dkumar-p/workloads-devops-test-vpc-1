#!/bin/bash

sudo su -

sudo yum install httpd -y
systemctl start httpd
systemctl status httpd
systemctl enable httpd