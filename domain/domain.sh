#!/bin/sh
# domain : 사용자 도메인 주소

domain=$1
########## 메뉴 출력 ###########

echo
echo --------------------------------------------
echo
echo       "     Domain 생성 스크립트      "
echo
echo --------------------------------------------
echo


########## 도메인 생성 확인 ############

#echo -n " 생성 할 Domain 명을 입력하세요 :  "
#	read domain

echo " 입력한 Domain 명 : $domain  "
echo " www.${domain} 으로 도메인을 생성합니다. "

########## 네임 서버 추가 등록 ###########

echo "
zone \"${domain}\" IN { 
	type master; 
	file \"${domain}.zone\"; 
	allow-transfer {192.168.8.155;};
	allow-update { none; }; 
};
" >> /etc/named.rfc1912.zones

########## 존 파일 생성 #############

cd /var/named/
touch ${domain}.zone

echo "\$TTL 60
@         IN SOA    ns   webmaster.${domain}.com. ( $(date +%Y%m%d)01 3H 15M 1W 1D )

          IN NS     ns
          IN MX 10  mail
          IN A      192.168.8.155
ns        IN A      192.168.8.156
www       IN A      192.168.8.155
mail      IN A      192.168.8.155
" >> /var/named/${domain}.zone

########## 권한 변경 및 확인 #############

chgrp named ${domain}.zone
chmod o= ${domain}.zone

named-checkconf /etc/named.rfc1912.zones
named-checkzone ${domain} ${domain}.zone

########## 네임 서버 재시작 ###########

/etc/init.d/named restart

########## 도메인 등록 확인 ###########

echo " www.${domain} 으로 도메인이 생성되었습니다. "
for i in ${domain}
	do
		echo " -- www.${i} -- "
		dig @localhost ${i} +short
		dig @localhost www.${i} +short
		dig @localhost ns.${i} +short
		echo
	done


######### 웹서버 등록 및 추가 ###########
cd
#########################################


######### 2차 도메인 접속 ###########

#echo "     2 차 도메인 등록을 시작합니다     "
#sshpass -ptkdhkxkfl1 ssh -T -o StrictHostKeyChecking=no root@192.168.8.132  "env domain=${domain} ~/HostingServer/domain2.sh \${domain}" <<'ENDSSH'

#cd HostingServer
#sh domain2.sh

#ENDSSH
