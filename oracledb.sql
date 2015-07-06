#可用实际的用户名替换aaa

create user aaa_v2 identified by aaa;

alter user aaa_v2 default tablespace data1;

grant connect,resource,dba to aaa_v2 ;

# drop user aaa cascade;
# password ittbank( 在用户已经连接的情况下 )或者
# alter user ittbank identified by newpassword



# 创建表空间

create tablespace data1 datafile '/u02/oradata/aaa/data1_01.dbf' size 20000m autoextend on next 100M;
alter tablespace data1 add datafile  '/u02/oradata/aaa/data1_02.dbf' size 20000m autoextend on next 100M;
alter tablespace data1 add datafile  '/u02/oradata/aaa/data1_03.dbf' size 20000m autoextend on next 100M;
alter tablespace data1 add datafile  '/u02/oradata/aaa/data1_04.dbf' size 20000m autoextend on next 100M;
alter tablespace data1 add datafile  '/u02/oradata/aaa/data1_05.dbf' size 20000m autoextend on next 100M;
alter tablespace data1 add datafile  '/u02/oradata/aaa/data1_06.dbf' size 20000m autoextend on next 100M;
 

create tablespace data2 datafile '/u02/oradata/aaa/data2_01.dbf' size 20000m autoextend on next 100M;
alter tablespace data2 add datafile  '/u02/oradata/aaa/data2_02.dbf' size 20000m autoextend on next 100M;
alter tablespace data2 add datafile  '/u02/oradata/aaa/data2_03.dbf' size 20000m autoextend on next 100M;
alter tablespace data2 add datafile  '/u02/oradata/aaa/data2_04.dbf' size 20000m autoextend on next 100M;
alter tablespace data2 add datafile  '/u02/oradata/aaa/data2_05.dbf' size 20000m autoextend on next 100M;
alter tablespace data2 add datafile  '/u02/oradata/aaa/data2_06.dbf' size 20000m autoextend on next 100M;


# drop tablespace data1 including contents and datafiles;


nohup imp userid=aaa_v2/aaa file=aaa.dmp fromuser=aaa_v2 touser=aaa_v2 buffer=10000000 log=./imp.log &


select 
b.file_name 物理文件名,
b.tablespace_name 表空间,
b.bytes/1024/1024 大小M,
(b.bytes-sum(nvl(a.bytes,0)))/1024/1024  已使用M,
substr((b.bytes-sum(nvl(a.bytes,0)))/(b.bytes)*100,1,5)  利用率 
from dba_free_space a,dba_data_files b 
where a.file_id=b.file_id 
group by b.tablespace_name,b.file_name,b.bytes 
order by b.tablespace_name
