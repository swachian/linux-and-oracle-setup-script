system及sysaux的表空间，查询空闲百分比时，总是显示的比较小。
研究一番可以发现，其实并无害处，因为表空间对应的数据文件是自动增长的，只是每次增长的数据极小，大约是1280*8192B，即每次只增加1MB，因此最终总是会出现空闲率不及1%的情况
最简单的办法就是调整每次扩大的值，这样就可以提升扩展后的空闲率

### 查询表空间是否自增长，最大允许的字节数等信息

`select tablespace_name,file_name, AUTOEXTENSIBLE,bytes,maxbytes, INCREMENT_BY from dba_data_files;`

```bash
TABLESPACE_NAME          FILE_NAME                                            AUT   BYTES   MAXBYTES INCREMENT_BY
------------------------------ --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --- ---------- ---------- ------------
USERS            /home/oracle/oradata/ngn/users01.dbf                                     YES 5282201600 3.4360E+10     160
SYSAUX             /home/oracle/oradata/ngn/sysaux01.dbf                                      YES  471859200 3.4360E+10   64000
UNDOTBS1           /home/oracle/oradata/ngn/undotbs01.dbf                                     YES 1032847360 3.4360E+10     640
SYSTEM             /home/oracle/oradata/ngn/system01.dbf                                      YES  587202560 3.4360E+10   64000
DATA2            /home/oracle/oradata/ngn/data2.dbf                                     YES 2831155200 3.4360E+10   12800
DATA1            /home/oracle/oradata/ngn/data1.dbf                                     YES 2.0867E+10 3.4360E+10   12800

```

160,12800是指每次增加的block数量，通常一个block有8192个字节

### 调整每次增长的大小

```bash
alter database datafile '/home/oracle/oradata/ngn/system01.dbf' autoextend on next 500m;
alter database datafile '/home/oracle/oradata/ngn/sysaux01.dbf' autoextend on next 500m;
```

### 查看表空间的比例状况

```
select dbf.tablespace_name,
dbf.totalspace "总量(TG)",
dfs.freespace "剩余总量(RG)",
(dfs.freespace / dbf.totalspace) * 100 "F空闲比例" 
from (select t.tablespace_name,
sum(t.bytes) / 1024 / 1024/1024 totalspace 
from dba_data_files t 
group by t.tablespace_name) dbf,
(select tt.tablespace_name,
sum(tt.bytes) / 1024 / 1024/1024 freespace
 from dba_free_space tt
 group by tt.tablespace_name) dfs
  where trim(dbf.tablespace_name) = trim(dfs.tablespace_name);

```
