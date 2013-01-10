#!/bin/bash

LR=liferay-portal-tomcat-6.0-ee-sp1
TOMCAT=tomcat-6.0.29

mkdir -p /vagrant/liferay/deploy
chown -R liferay /vagrant/liferay

mkdir /usr/local/liferay
cd /usr/local/liferay
unzip /vagrant/$LR.zip >/dev/null || exit 255

echo "auto.deploy.dest.dir=/vagrant/liferay/deploy" > /usr/local/liferay/$LR/$TOMCAT/webapps/ROOT/WEB-INF/classes/portal-ext.properties

chown -R liferay $LR
cd $LR/$TOMCAT || exit 255


su - liferay -c ./bin/startup.sh
