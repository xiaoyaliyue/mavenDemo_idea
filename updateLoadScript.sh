##--连接服务器，上传文件
#echo "开始上传文件"
#pscp -l work -pw qazwsx@123 -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/deploy
#scp -l work -pw qazwsx@123 -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/deploy
#echo "上传文件成功"


##--开始部署

#!/bin/bash  

#ssh -p 10022 root@47.112.139.67 "cd /home/work/;sh -x ./deploy.sh 
ssh root@47.112.139.67  'cd /home/work;sh deploy.sh'
echo "hello"



