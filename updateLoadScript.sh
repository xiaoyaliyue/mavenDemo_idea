##--连接服务器，上传文件
#echo "开始上传文件"
#pscp -l work -pw qazwsx@123 -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/deploy
#scp -l work -pw qazwsx@123 -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/deploy
#echo "上传文件成功"


##--开始部署

#!/bin/bash  
#ssh work@47.112.139.67   << remotessh  

##--项目war包名称 mavenDemo_idea-1.6.war
project_name=$1
##--项目部署目录 /home/work/apache-tomcat-7.0.79/webapps/
project_dir=$2
##--上传包临时存放目录:/home/work/deploy
deploy_dir=$3
##--程序备份目录
backup_dir=/home/work/backup
##--tomcat  /home/work/apache-tomcat-7.0.79
tomcat_name=$5


##--页面访问地址：http://47.112.139.67:8080/mavenDemo_idea-1.6
WebUrl=$6  


##--Tomcat启动脚本
tomcatStart_shell=$tomcat_name/bin/startup.sh

##--1备份
  if [ -d $backup_dir ] ;then
  echo "$backup_dir目录存在，开始备份"
  else 
mkdir $backup_dir
   fi
   cp -r $project_dir/$project_name $backup_dir/$project_name_'date +%Y%m%d'



##--2杀进程
PID=$(ps -ef | grep $tomcat_name | grep java | grep -v grep | awk '{ print $2 }')
if [ -z "$PID"];then
echo "$SERVICE_NAME进程不存在，无需关闭进程，开始备份部署........"
else
echo "当前服务进程是：$PID，开始停进程"
kill -9 $PID
echo “等待10秒”
sleep 10；
echo “完成停进程，开始检查进程状态”
for i in (1..10)
do
echo "开始第$i/10次检查"
count_PID=$(ps -ef|grep $PID |grep -v "grep" |wc -l )
echo "-gt 大于 输出的进程个数大于0，当前进程未关闭"
if [$count_PID -gt 0]
then 
echo "当前进程 $PID 未关闭，等待5秒后进行下一次检查"
        sleep 5;
else 
        echo "当前进程$PID已关闭"
 break
fi
done
fi
echo "开始解压部署程序包"
rm -rf $project_dir/$project_name
\cp -rf $deploy_dir/$project_name -C $project_dir
if [$?==0]
then
echo "解压部署包$deploy_dir/$project_name到$project_dir/$project_name成功"
echo "启动程序"
sh $tomcatStart_shell
echo “检查URL"
if [ -z "$WebUrl" ];
         then
         echo "无登录地址，无法检测页面是否正常"
         else
	TomcatServiceCode=$(curl -L -s -o -m 20 --connect-timeout 20  -w%{http_code} $WebUrl | sed '/^$/!h;$!d;g' | grep -o '[0-9]\{3\}' | awk 'END {print}' )
	if [ $TomcatServiceCode -eq 200 ];then
	   echo "页面返回码为$TomcatServiceCode,启动成功,测试页面正常......"
	else
	    echo "页面访问失败，请检查报错"
		exit 1
	fi
	fi	


fi

ehco  "部署完成。"


#exit  
#remotessh  



