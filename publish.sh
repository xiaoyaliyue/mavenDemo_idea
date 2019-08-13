#!/bin/bash  

echo "start scp war to linux"
scp -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war root@47.112.139.67:/home/work/deploy
echo "scp war to linux ok "

##--项目war包名称 mavenDemo_idea-1.6.war
project_name=mavenDemo_idea-1.6.war
##--项目部署目录 /home/work/apache-tomcat-7.0.79/webapps/
project_dir=/home/work/apache-tomcat-7.0.79/webapps
##--上传包临时存放目录:/home/work/deploy
deploy_dir=/home/work/deploy
##--程序备份目录
backup_dir=/home/work/backup
##--tomcat  /home/work/apache-tomcat-7.0.79
tomcat_name=/home/work/apache-tomcat-7.0.79

nowDate='date +%Y%m%d%H%M%S'
##--页面访问地址：http://47.112.139.67:8080/mavenDemo_idea-1.6
WebUrl=http://47.112.139.67:8080/mavenDemo_idea-1.6


##--Tomcat启动脚本
tomcatStart_shell=$tomcat_name/bin/startup.sh

##--1备份
  if [ -d $backup_dir ]
  then
  echo "$backup_dir is true,start backup"
  else 
  mkdir $backup_dir
   fi
    #cp -r /home/work/apache-tomcat-7.0.79/webapps/mavenDemo_idea-1.6.war /home/work/backup/mavenDemo_idea-1.6.war_$(date +%Y%m%d_%H%M%S)
	echo "1"
   #cp -r ${project_dir}/${project_name} ${backup_dir}/${project_name}-$(date +%Y%m%d_%H%M%S)
	
   cp -r $project_dir/$project_name $backup_dir/$project_name-$(date +%Y%m%d_%H%M%S)
	

##--2  kill pid
	PID=$(ps -ef | grep $tomcat_name | grep java | grep -v grep | awk '{ print $2 }')
	if [ -z "$PID" ]
	then
	echo "$SERVICE_NAME kill is not,no need to kill pid,start deploy........"
	else
	echo "now pid:$PID isstop"
	kill -9 $PID
	fi
	
echo "sleep 5"
sleep 5
echo "stop ok,check pid status"
for i in {1..10}
do
echo "start the $i/10 check"
count_PID=$(ps -ef | grep $PID | grep -v "grep" | wc -l )
echo "-gt>0,$PID is not kill"
if [ $count_PID -gt 0 ]
then 
echo "now $PID is not stop，wait for 5 for next check "
        sleep 5
else 
        echo "now pid:$PID is stop"
 break
fi
done

echo "start deploy war"
rm -rf $project_dir/$project_name
cp -rf $deploy_dir/$project_name  $project_dir
if [ $? == 0 ]
	then
	echo "deploy $deploy_dir/$project_name to $project_dir/$project_name success"
	echo "start war"
fi
sh $tomcatStart_shell
echo "sleep 20"
sleep 20

echo "check URL:$WebUrl"
if [ -z "$WebUrl" ];
	then
	echo "无登录地址，无法检测页面是否正常"
else
		#TomcatServiceCode=$(curl -L -s -o -m 20 --connect-timeout 20  -w%{http_code} $WebUrl | sed '/^$/!h;$!d;g' | grep -o '[0-9]\{3\}' | awk 'END {print}' )
	TomcatServiceCode=$(curl -L -s -o -m 20 --connect-timeout 20  -w%{http_code} http://47.112.139.67:8080/mavenDemo_idea-1.6 | sed '/^$/!h;$!d;g' | grep -o '[0-9]\{3\}' | awk 'END {print}' )
	echo "check url:$TomcatServiceCode"
	if [ $TomcatServiceCode -eq 200 ]
	then
	    echo "url $TomcatServiceCode,start ok,url ok....."
	else
	    echo "url error,check url"
		exit 1
	fi
fi
