#!/bin/bash
set -e

VERSION="3.4.10"
REVISION=1

rm -rf zabbix-3.4.*
rm -rf ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION-$REVISION.el7.x86_64.rpm
rm -rf ~/rpmbuild/SOURCES/zabbix-$VERSION

wget https://repo.zabbix.com/zabbix/3.4/rhel/7/SRPMS/zabbix-$VERSION-$REVISION.el7.src.rpm
rpm -ivh zabbix-$VERSION-$REVISION.el7.src.rpm
cd ~/rpmbuild/SOURCES
tar -xzf zabbix-$VERSION.tar.gz
sed -i "s/String key = property.getKey().toUpperCase();/String key = property.getKey().toUpperCase().replace('-', '_');/g" ~/rpmbuild/SOURCES/zabbix-$VERSION/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java

rm -rf ~/rpmbuild/SOURCES/zabbix-3.4.*.gz
cd ~/rpmbuild/SOURCES/ && tar -czf zabbix-$VERSION.tar.gz zabbix-$VERSION
cd ~/ && rpmbuild -ba ~/rpmbuild/SPECS/zabbix.spec
rpm -qip ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION-$REVISION.el7.x86_64.rpm

scp rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION-$REVISION.el7.x86_64.rpm root@tomashermanek.cz:/var/www/coreit.cz/web/download/
