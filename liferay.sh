#!/bin/bash

# Liferay version
LR="liferay-portal-6.1.1-ce-ga2" # Name of the release
TOMCAT="tomcat-7.0.27" # Bundled tomcat version
LR_ZIP="${LR}-20120731132656558.zip" # Name of zip distribution

# Create dir structure
mkdir -p /vagrant/liferay/deploy
chown -R vagrant /vagrant/liferay
mkdir -p /usr/local/liferay/
cd /usr/local/liferay/

# Unzip, setup autodeploy and start..
echo "Unzip /vagrant/${LR}.zip"
unzip /vagrant/${LR_ZIP} >/dev/null || exit 255
echo "auto.deploy.dest.dir=/vagrant/liferay/deploy" > /usr/local/liferay/${LR}/${TOMCAT}/webapps/ROOT/WEB-INF/classes/portal-ext.properties
chown -R vagrant /usr/local/liferay/${LR}
echo "Starting tomcat...."
su - vagrant -c /usr/local/liferay/${LR}/${TOMCAT}/bin/startup.sh
