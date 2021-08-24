#!/bin/bash
#
#////////////////////////////////////////////////////////////
#===========================================================
# uptime360 Monitor - Installer v1.0
#===========================================================
echo "--------------------------------"
echo " Welcome to Uptime360 Monitor Installer"
echo "--------------------------------"
echo " "

# Are we running as root
if [ $(id -u) != "0" ]; then
	echo "Uptime360 Agent installer needs to be run with root privileges"
	echo "Try again with root privileges"
	echo "=-----------==========--------------="
	exit 1;
fi

#check if nginx is installed
#if dpkg -l nginx > /dev/null 2>&1; then
#    echo "Nginx is installed already."
#fi

#if ! dpkg -l nginx > /dev/null 2>&1; then
#    echo "Nginx not installed. The installation will start now..."
#    apt-get install -y nginx
#fi


# RHEL / CentOS / etc
if [ -n "$(command -v yum)" ]; then
	yum -y install cronie gzip curl
	service crond start
	chkconfig crond on

	# Check if unzip available or not
	if ! type "unzip" ; then
		yum -y install unzip
	fi

	# Check if curl available or not
	if ! type "curl" ; then
		yum -y install curl
	fi

	#check if php installed
	if ! type "php72" ; then
	     yum update
	     yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	     yum -y install yum-utils
	     yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	     yum-config-manager --enable remi-php72
	     yum install php72 php72-php-fpm php72-php-mysqlnd php72-php-opcache php72-php-xml php72-php-xmlrpc php72-php-gd php72-php-mbstring php72-php-json
	fi

	#check if php not installed correctly
    if ! type "php72" ; then
        echo "The php was not installed correctly"
        echo "Try again....."
        exit 1;
    fi
fi

# Debian / Ubuntu
if [ -n "$(command -v apt-get)" ]; then
	apt-get update -y
	apt-get install -y cron curl gzip
	service cron start

	# Check if unzip available or not
	if ! type "unzip" ; then
		apt-get install -y unzip
	fi

	# Check if curl available or not
	if ! type "curl" ; then
		apt-get install -y curl
	fi

	#check if php is installed
	if ! type "php" ; then
	    apt-get update && apt-get upgrade
	    apt-get install -y php
	fi

	#check if php not installed correctly
    if ! type "php" ; then
        echo "The php was not installed correctly"
        echo "Try again....."
        exit 1;
    fi
fi

# Is CURL available?
if [  ! -n "$(command -v curl)" ]; then
	echo "CURL is required but we could not install it."
	echo "Exiting installer"
	exit 1;
fi

#check if unzip installed correctly
if ! type "unzip" ; then
	echo "The unzip was not installed correctly"
	echo "Try again....."
	apt-cache search php7
	apt-get install -y php7.2
fi


#target url from where the monitor station's package can be installed = $1
wget -P /var https://my.uptime360.net/assets/monitorstation.zip

if type "unzip"; then
    mkdir /var/monitorstation
    unzip /var/monitorstation.zip -d /var/monitorstation
    rm /var/monitorstation.zip
    rm -r monitor.sh
fi

echo " "
echo "-------------------------------------"
echo " Installation Completed "
echo "-------------------------------------"
echo " "
