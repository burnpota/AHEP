#!/bin/sh

### PATHDIR 변수에는 sedget.sh 파일이 있는 디렉터리로 설정할 것
PATHDIR=/root

netstat -nlpt | grep 8888 >& /dev/null
if [ $? -eq 1 ]
then
	nohup $PATHDIR/hostget.py & \r\n
fi


if [ -f /hostlist ]
then
	$PATHDIR/sedget.sh
	rm -f /hostlist
fi
