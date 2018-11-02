#!/bin/sh

LINE=$(wc -l hostlist | awk '{print $1}')
### PATHDIR 변수에 vpop.sh 파일이 포함된 디렉터리를 설정할 것
PATHDIR=/root
for i in $(seq $LINE)
do
	$PATHDIR/vpop.sh $(sed -n ${i}'p' hostlist)
done

	
