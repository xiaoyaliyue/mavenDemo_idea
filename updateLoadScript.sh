--连接服务器，上传文件
echo "开始上传文件"
pscp -l work -pw qazwsx@123 -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/apache-tomcat-7.0.79/webapps
echo "上传文件成功"


--开始部署

#!/bin/bash  
ssh root@192.168.0.23   << remotessh  

--项目war包名称
project_name=$1
--项目部署目录
project_dir=$2
--上传包临时存放目录
deploy_dir=$3
--程序备份目录
backup_dir=$4

--1备份
  




--2杀进程

--3部署包

--4重启

--5检查URL

killall -9 java  
cd /data/apache-tomcat-7.0.53/webapps/  
exit  
remotessh  
