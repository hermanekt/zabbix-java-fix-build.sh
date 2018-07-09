#!/bin/bash
set -e

VERSION="3.4.11"
REVISION=1

rm -rf zabbix*

apt-get update
apt-get source zabbix

sed -i "s/String key = property.getKey().toUpperCase();/String key = property.getKey().toUpperCase().replace('-', '_');/g" zabbix-$VERSION/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java

apt-get build-dep zabbix
cd zabbix-$VERSION 
debuild  -b -us -uc
