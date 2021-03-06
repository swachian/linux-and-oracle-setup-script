mount /dev/sr0  /media/CentOS_6.4_Final

rm -rf /etc/yum.repos.d/*
scp db01:/etc/yum.repos.d/* /etc/yum.repos.d/

rm -rf rlwrap-0.37
tar -zxvf rlwrap-0.37.tar.gz
cd rlwrap-0.37 && ./configure && make && make install

echo "session    required     pam_limits.so" >> /etc/pam.d/login

yum install compat-libstdc++-33-3*  compat-gcc-34-3*  compat-gcc-34-c++-3*  gcc-4*  libXp-1*
yum install  openmotif-2*  compat-db-4*

yum install -y libXp-devel.i686  libXt.i686 libXtst.i686 compat-gcc* compat-glibc* compat-libstd* glibc-devel.i686 libaio-devel.i686
yum install libXp.i686 libXp-devel.i686 libXt.i686 libXt-devel.i686 libXtst.i686 libXtst-devel.i686 make.x86_64 gcc.x86_64 libaio.x86_64 glibc-devel.i686 libgcc.i686
glibc-devel.x86_64 compat-libstdc++-33 -y
yum install glibc* gcc* make* compat-db* libstdc* libXp* libXtst* compat-libstdc++* -y


groupadd oinstall
groupadd dba
groupadd oper

useradd -g oinstall -G dba oracle
passwd oracle

mkdir -p /u01/app/oracle/product/10.2.0/db_1
chown -R oracle.oinstall /u01

echo "Red Hat Enterprise Linux AS release 4 (Nahant Update 4)" > /etc/redhat-release


cat >> /home/oracle/.bash_profile <<"EOF"
TMP=/tmp; export TMP
TMPDIR=$TMP; export TMPDIR

ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1; export ORACLE_HOME
ORACLE_SID=sid; export ORACLE_SID
ORACLE_TERM=xterm; export ORACLE_TERM
PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH

LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH

if [ $USER = "oracle" ]; then
  if [ $SHELL = "/bin/ksh" ]; then
    ulimit -p 16384
    ulimit -n 65536
  else
    ulimit -u 16384 -n 65536
  fi
fi

alias udump="cd $ORACLE_BASE/admin/$ORACLE_SID/udump"
alias bdump="cd $ORACLE_BASE/admin/$ORACLE_SID/bdump"
alias sqlplus="rlwrap sqlplus"

EOF

#gunzip 1.10201_database_linux_x86_64.cpio.gz
#cpio -idmv < 1.10201_database_linux_x86_64.cpio 

