#!/bin/sh

pwdir=$(pwd)

### crond 실행 여부 확인 ###
pstree | grep crond >& /dev/null

if [ $? -eq 1 ]
then
	service crond start ### crond가 실행되지 않을 경우 실행
fi
	### hostlist 파일을 자동 기능이 cron 설정에 포함됐는지 확인
grep 'hostsend.py' /etc/crontab >& /dev/null

if [ $? -eq 1 ]
then
		### 10분마다 hostlist 파일을 전송할 수 있도록 crontab 설정
	echo "*/1 * * * * root "$pwdir"/hostsend.py" >> /etc/crontab 
fi

