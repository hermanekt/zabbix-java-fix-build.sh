#!/bin/bash
# OS dependencies
# yum install -y https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
# yum install -y wget rpm-build make gcc mysql-devel postgresql-devel net-snmp-devel openldap-devel gnutls-devel sqlite-devel unixODBC-devel curl-devel OpenIPMI-devel libssh2-devel java-devel libxml2-devel pcre-devel libevent-devel openssl-devel iksemel-devel

# Example usage ./centos-PRE-zabbix-java-fix-build.sh "4.2" "rc" "5" "1"

set -e

VERSION=$1
RELEASE="0-0"
REVISION=$2$4
VERSION_REPO=4.1

rm -rf *.src.rpm
rm -rf ~/rpmbuild/*
#https://repo.zabbix.com/zabbix/4.1/rhel/7/SRPMS/zabbix-4.2.0-0.5rc.el7.src.rpm
#https://repo.zabbix.com/zabbix/4.1/rhel/7/SRPMS/zabbix-4.2.0-0.5rc1.el7.src.rpm
wget https://repo.zabbix.com/zabbix/$VERSION_REPO/rhel/7/SRPMS/zabbix-$VERSION.$RELEASE.$3$REVISION.el7.src.rpm
rpm -ivh zabbix-$VERSION.$RELEASE.$3$REVISION.el7.src.rpm

rpm -ivh zabbix-4.2.0-0.$3$REVISION.el7.src.rpm

cd ~/rpmbuild/SOURCES

tar -xzf zabbix-$VERSION.0$REVISION.tar.gz
sed -i "s/String key = property.getKey().toUpperCase();/String key = property.getKey().toUpperCase().replace('-', '_');/g" ~/rpmbuild/SOURCES/zabbix-$VERSION.0$REVISION/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java

#OK
rm -rf ~/rpmbuild/SOURCES/zabbix-$VERSION.*.gz
echo tar

cd ~/rpmbuild/SOURCES/ && mv zabbix-$VERSION.0$REVISION zabbix-$VERSION.0
cd ~/rpmbuild/SOURCES/ && tar -czf zabbix-$VERSION.0.tar.gz zabbix-$VERSION.0
echo build

cd ~/ && rpmbuild -ba ~/rpmbuild/SPECS/zabbix.spec
rpm -qip ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION.0-$3.el7.x86_64.rpm

cd ~/Zabbix_wildfly_eap_jboss_monitoring
git pull
cp ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION.0-$3.el7.x86_64.rpm ./zabbix-java-gateway-$VERSION.$RELEASE.$3$REVISION.el7.x86_64.rpm
git add .
git commit -m "PRERELASED VERSION! Centos 7, RH7 version:$VERSION.-$REVISION"
git push

rm -rf ~/rpmbuild/*

