##--连接服务器，上传文件
echo "开始上传文件"
#pscp -l work -pw qazwsx@123 -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/deploy
scp -r C:\Users\tiger\.jenkins\workspace\pipelineDemo_deploy\target\mavenDemo_idea-1.6.war work@47.112.139.67:/home/work/deploy
echo "上传文件成功"
