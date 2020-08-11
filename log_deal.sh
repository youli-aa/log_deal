#!/bin/bash

log_store_path=/tmp/logs_deal/log_store/
mkdir -p $log_store_path # 创建日志备份存储路径
log_path='/tmp/packages/wiseasy_ciloud/logs/' #此路径为需处理日志的路径

time1=`/usr/bin/date +%F -d "yesterday" ` #压缩备份，归档前一日的日期
exec_log=/tmp/logs_deal/exec.log # 执行本脚本的日志

function  compress_log(){
      #压缩日志并copy到文件存储目录
      echo "开始压缩":$file
      tar -zcPf   $log_path$file-$time1.tar.gz $log_path$file
      echo "备份"$file"压缩文件到/root/log_deal/log_store/目录"

      mv $log_path$file-$time1.tar.gz $log_store_path
      echo "清除源数据":$file
      cat /dev/null  > $log_path$file
}

function delate_log(){
     #删除存储的30天以前的日志
     cd $log_store_path
     find -maxdepth 1 -type f -ctime +30 -name "*.tar.gz" -exec rm -rf  {} \;
}


cd $log_path

#遍历wieasy_cloud的日志目录中的日志文件
for file in *.log
do
    compress_log $file >> $exec_log
done

delate_log >> $exec_log

