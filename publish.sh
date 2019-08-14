#!/bin/bash  

echo "start scp war to linux"
scp -r C:/Users/tiger/.jenkins/workspace/pipelineDemo_deploy/target/mavenDemo_idea-1.6.war root@47.112.139.67:/home/work/deploy

echo "scp war to linux ok "

ssh root@47.112.139.67  'cd /home/work;sh deploy.sh'
echo "success"
