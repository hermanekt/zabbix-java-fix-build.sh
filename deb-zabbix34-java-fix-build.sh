#!/bin/bash
set -e
# apt-get install dpkg-dev devscripts build-essential lintian

cd ~/zabbix-java-fix-build.sh
dpkg --remove zabbix-release
rm -rf zabbix*
wget https://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb
dpkg -i zabbix-release_3.4-1+stretch_all.deb

apt-get update
apt-get source zabbix

sed -i "s/String key = property.getKey().toUpperCase();/String key = property.getKey().toUpperCase().replace('-', '_');/g" zabbix-*/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java

apt-get -y build-dep zabbix
cd zabbix-3.4*
debuild  -b -us -uc

cd ~/Zabbix_wildfly_eap_jboss_monitoring && git pull
cp ~/zabbix-java-fix-build.sh/zabbix-java-gateway_* ~/Zabbix_wildfly_eap_jboss_monitoring
cd ~/Zabbix_wildfly_eap_jboss_monitoring && git add . && git commit -m "Debian package" && git push

rm -rf ~/zabbix-java-fix-build.sh/zabbix*
