#!/bin/bash
cat << EOF
+--------------------------------------------------------------+
| === Welcome to Centos System init === |
+--------------------------------------------------------------+
+--------------------------by richard--------------------------+
EOF
 
chkconfig --level 35 iptables off
 
service crond restart

#set ulimit
echo "ulimit -SHn 65536" >> /etc/rc.local
 
cat >> /etc/security/limits.conf <<EOF
  * soft nofile 32768
  * hard nofile 32768
  oracle soft    nproc   2047
  oracle hard    nproc   16384
  oracle soft    nofile  4096
  oracle hard    nofile  65536
  oracle soft memlock 3145728
  oracle hard memlock 3145728
EOF
 
 
#set sysctl
true > /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
kernel.sem = 250 32000 100 128
fs.file-max = 65536
vm.overcommit_memory = 1
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
#vm.hugetlb_shm_group = 500 #500是oracle所在的groups
EOF
/sbin/sysctl -p
echo "sysctl set OK!!"
 
#disable ipv6
cat << EOF
+--------------------------------------------------------------+
| === Welcome to Disable IPV6 === |
+--------------------------------------------------------------+
EOF
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
/sbin/chkconfig --level 35 ip6tables off
echo "ipv6 is disabled!"
#disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
echo "selinux is disabled,you must reboot!"
#vim
sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
echo 'syntax on' > /root/.vimrc
 
 
#chkser
#tunoff services
#--------------------------------------------------------------------------------
cat << EOF
+--------------------------------------------------------------+
| === Welcome to Tunoff services === |
+--------------------------------------------------------------+
EOF
#---------------------------------------------------------------------------------
for i in `ls /etc/rc3.d/S*`
do
CURSRV=`echo $i|cut -c 15-`
echo $CURSRV
case $CURSRV in
crond | irqbalance | microcode_ctl | rpcbind | haldaemon | messagebus | network | random | sshd | syslog | local )
echo "Base services, Skip!"
;;
*)
echo "change $CURSRV to off"
chkconfig --level 235 $CURSRV off
service $CURSRV stop
;;
esac
done
echo "service is init is ok.............."
 
 
echo "nameserver 202.96.209.5" > /etc/resolv.conf
 
