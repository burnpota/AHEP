#!/bin/sh

### PATHDIR �������� sedget.sh ������ �ִ� ���͸��� ������ ��
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
