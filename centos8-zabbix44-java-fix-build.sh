#!/bin/bash
# OS dependencies
# yum install -y https://repo.zabbix.com/zabbix/4.4/rhel/8/x86_64/zabbix-release-4.4-0.el7.noarch.rpm
# yum install -y wget rpm-build make gcc mysql-devel postgresql-devel net-snmp-devel openldap-devel gnutls-devel sqlite-devel unixODBC-devel curl-devel OpenIPMI-devel libssh2-devel java-devel libxml2-devel pcre-devel libevent-devel openssl-devel iksemel-devel

# Example usage ./centos-zabbix-java-fix-build.sh "4.4" "0" "1"

set -e

VERSION=$1
RELEASE=$2
REVISION=$3

rm -rf zabbix-$VERSION.*
rm -rf ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION.$RELEASE-$REVISION.el8.x86_64.rpm
rm -rf ~/rpmbuild/SOURCES/zabbix-$VERSION

wget https://repo.zabbix.com/zabbix/$VERSION/rhel/8/SRPMS/zabbix-$VERSION.$RELEASE-$REVISION.el8.src.rpm
rpm -ivh zabbix-$VERSION.$RELEASE-$REVISION.el8.src.rpm


cd ~/rpmbuild/SOURCES
tar -xzf zabbix-$VERSION.$RELEASE.tar.gz
sed -i "s/String key = property.getKey().toUpperCase();/String key = property.getKey().toUpperCase().replace('-', '_');/g" ~/rpmbuild/SOURCES/zabbix-$VERSION.$RELEASE/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java

rm -rf ~/rpmbuild/SOURCES/zabbix-$VERSION.*.gz
cd ~/rpmbuild/SOURCES/ && tar -czf zabbix-$VERSION.$RELEASE.tar.gz zabbix-$VERSION.$RELEASE


sed -i "s/%define build_agent2 1/%define build_agent2 0/g" ~/rpmbuild/SPECS/zabbix.spec
sed -i '/BuildRequires:\slibssh2-devel.*/d' ~/rpmbuild/SPECS/zabbix.spec
sed -i '/--with-ssh2/d' ~/rpmbuild/SPECS/zabbix.spec


cd ~/ && rpmbuild -ba ~/rpmbuild/SPECS/zabbix.spec
#rpm -qip ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION.$RELEASE-$REVISION.el8.x86_64.rpm

cd ~/Zabbix_wildfly_eap_jboss_monitoring
git pull
cp ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION.$RELEASE-$REVISION.el8.x86_64.rpm .
git add .
git commit -m "Centos 8, RH8 version:$VERSION.$RELEASE-$REVISION"
git push


#cp ~/rpmbuild/RPMS/x86_64/zabbix-java-gateway-$VERSION.$RELEASE-$REVISION.el8.x86_64.rpm /root/

rm -rf ~/rpmbuild/*

