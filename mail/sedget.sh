#!/bin/sh

LINE=$(wc -l hostlist | awk '{print $1}')
### PATHDIR ������ vpop.sh ������ ���Ե� ���͸��� ������ ��
PATHDIR=/root
for i in $(seq $LINE)
do
	$PATHDIR/vpop.sh $(sed -n ${i}'p' hostlist)
done

	
