#!/bin/bash
# Start build servers
sshpass -p 'VMWARE_PASS' ssh root@192.168.LOCAL_IP "vim-cmd vmsvc/power.on 38"
sshpass -p 'VMWARE_PASS' ssh root@192.168.LOCAL_IP "vim-cmd vmsvc/power.on 39"

# Time to boot up 
sleep 30 

# Centos 7
ssh root@192.168.LOCAL.IP /root/zabbix-java-fix-build.sh/centos-PRE-zabbix-java-fix-build.sh "4.2" "beta" "1"
#ssh root@192.168.LOCAL.IP /root/zabbix-java-fix-build.sh/centos-zabbix-java-fix-build.sh "4.0" "5" "1"

# Debian 9
ssh root@192.168.LOCAL.IP /root/zabbix-java-fix-build.sh/deb-PRE-zabbix-java-fix-build.sh
#ssh root@192.168.LOCAL.IP /root/zabbix-java-fix-build.sh/deb-zabbix-java-fix-build.sh

# Shutdown machine after build and push
ssh root@192.168.LOCAL.IP init 0
ssh root@192.168.LOCAL.IP init 0

