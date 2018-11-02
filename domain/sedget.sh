#!/bin/sh

LINE=$(wc -l hostlist | awk '{print $1}')
PATHDIR=/root
for i in $(seq $LINE)
do
	$PATHDIR/domain.sh $(sed -n ${i}'p' hostlist)
done

	
