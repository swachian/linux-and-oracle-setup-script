/u01/app/oracle/oraInventory/orainstRoot.sh
/u01/app/oracle/product/10.2.0/db_1/root.sh

scp oracle@yws01:/u01/app/oracle/product/10.2.0/db_1/network/admin/tnsnames.ora /u01/app/oracle/product/10.2.0/db_1/network/admin/
chown oracle:oinstall /u01/app/oracle/product/10.2.0/db_1/network/admin/tnsnames.ora
su - oracle -c "chmod a+rX $ORACLE_HOME"
