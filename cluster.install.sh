yum install rgmanager lvm2-cluster gfs2-utils ricci

yum install luci

service ricci  start
service cman start
service clvmd start
service gfs2 start
service rgmanager start

chkconfig cman ricci clvmd gfs2 rgmanager
