#!/bin/bash

domain=$1
for i in $domain
do
    vadddomain $i 111111
    echo "$i 도메인 추가"

    echo "$i" >> /var/qmail/control/rcpthosts
    vadduser webmaster@$i 1111111
    echo "webmaster@$i 유저생성완료"
done



