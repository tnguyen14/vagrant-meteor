#!/usr/bin/env bash

# Capture a basic ping result to Google's primary DNS server to determine if
# outside access is available to us. If this does not reply after 2 attempts,
# we try one of Level3's DNS servers as well.
ping_result="$(ping -c 2 8.8.4.4 2>&1)"
if [[ $ping_result != *bytes?from* ]]; then
	ping_result="$(ping -c 2 4.2.2.2 2>&1)"
fi

if [[ $ping_result == *bytes?from* ]]; then
	echo "External network connection established,"
else
	echo "No external network available."
fi

apt_packages_to_install=(
	curl
	g++
	python
	make
	checkinstall
	git
	mongodb-10gen
	nodejs
)

# Launchpad nodejs key C7917B12
gpg -q --keyserver keyserver.ubuntu.com --recv-key C7917B12
gpg -q -a --export  C7917B12  | apt-key add -
# Launchpad git key A1715D88E1DF1F24
gpg -q --keyserver keyserver.ubuntu.com --recv-key A1715D88E1DF1F24
gpg -q -a --export A1715D88E1DF1F24 | apt-key add -
# Mongodb
# gpg -q --keyserver keyserver.ubuntu.com --recv-key 7F0CEB10
# gpg -q -a --export  7F0CEB10  | apt-key add -
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

apt-get update --assume-yes

apt-get install --assume-yes python-software-properties
add-apt-repository ppa:chris-lea/node.js

apt-get update --assume-yes

# apt-get upgrade --assume-yes

echo "Installing packages"
apt-get install --assume-yes ${apt_packages_to_install[@]}

apt-get clean

echo "Restarting mongo"
service mongodb restart

# Install Meteor
curl https://install.meteor.com | /bin/sh
echo "Meteor Installed - Running Version"
meteor --version
