#!/bin/bash

domain=$1
for i in $domain
do
    vadddomain $i 111111
    echo "$i ������ �߰�"

    echo "$i" >> /var/qmail/control/rcpthosts
    vadduser webmaster@$i 1111111
    echo "webmaster@$i ���������Ϸ�"
done



