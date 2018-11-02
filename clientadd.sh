#!/bin/sh

HTTPDC=/etc/httpd/conf/httpd.conf
failDNS=You_Must_RESEND_hostname.tmp_To_DNSserver
failMAIL=You_Must_RESEND_hostname.tmp_To_MAILserver
###메뉴 출력 함수###
menu()
{
	echo ' ============================== '
	echo '  상품을 선택해주시기 바랍니다. '
	echo ' ============================== '
	echo '  1)    500MB'
	echo '  2)    1GB'
	echo '  3)    2GB'
	echo '  4)    5GB'
	echo '  5)    10GB'
	echo '  6)    15GB'
	echo '  r)    돌아가기'
}

### 호스트 추가 함수###
user_add()
{
	echo '  호스트명을 입력해주시기 바랍니다.'
	### 호스트명 입력 오류시 처음부터 다시 입력할 수 있도록 while 반복문 사용
	while : 
	do
		read -p ' 입력 : ' namehost ### 호스트명 입력
		if [ -d /home/$namehost ] ### 호스트명 중복 확인
		then
			echo "  오류 :: 이미 존재하는 호스트 명입니다"
			echo "  다시 입력해주시기 바랍니다"
		else
			useradd -g 100 $namehost
			if [ $? -eq 3 ] ### 백스페이스 등으로 유저생성이 불가능한지 여부 확인
			then
				echo " 오류 :: 호스트명을 다시 입력해주시기 바랍니다"
			 
			else
				echo '  패스워드를 입력해주시기 바랍니다.'
				passwd $namehost ### 패스워드 입력
				break ###호스트 생성 및 비밀번호 설정이 완료되면 while문 종료
			fi
		fi
	done	
}

### 클라이언트에게 할당할 lvm 논리볼륨 생성함수 ###
### lvmcreate 호스트명  구매 용량
lvmcreate()
{
	lvcreate -n $namehost -L $1 HOSTING ### 논리 볼륨 생성
	if [ $? -eq 5 ]
	then
		echo "LVM 볼륨 그룹에 충분한 공간이 남아있지 않습니다."
		echo "논리 볼륨의 공간을 확장해주시기 바랍니다."
		break
	fi
	mkfs.ext4 /dev/HOSTING/$namehost ### ext4 형식으로 디스크 포맷
	mount /dev/HOSTING/$namehost /home/$namehost ### 클라이언트 폴더에 마운트
	chown $namehost /home/$namehost
	chgrp users /home/$namehost
	echo '========================================================================='
	echo '                             호스팅 생성 완료                            '
	echo '========================================================================='
}
	
### 영구적으로 마운트하기 위해 fstab 설정 함수 ###
fstabconf()
{
	echo -n "UUID=" >> /etc/fstab
	echo -n $(blkid | grep $namehost | cut -d \" -f 2)  >> /etc/fstab
	echo -n "  " >> /etc/fstab
	echo -n /home/$namehost >> /etc/fstab
	echo -n "  " >> /etc/fstab
	echo -n $(blkid | grep $namehost | cut -d \" -f 4) >> /etc/fstab
	echo "  defaults     1  2" >> /etc/fstab
}

### httpd 설정옵션에 서버 정보 입력 ###
httpconf()
{
	echo '<VirtualHost *:80>' >> $HTTPDC
	echo '    ServerAdmin webmaster@'$namehost >> $HTTPDC
	echo '    DocumentRoot /home/'$namehost >> $HTTPDC
	echo '    ServerName '$namehost >> $HTTPDC
	echo '    ServerAlias www.'$namehost >> $HTTPDC
	echo '</VirtualHost>' >> $HTTPDC
}

###  ###

### case문에 반복 삽입될 함수 명령어 모음 ###
casein()
{
	TODAY=$(date +%Y%m%d%H%M)
	user_add ###호스트 생성
	lvmcreate $1 ### 호스트에 할당할 논리볼륨 생성
	fstabconf ### 파티션 영구 마운트 설정
	httpconf ### httpd 옵션 설정
	echo $namehost  >> hostname.tmp ### DNS 및 MAIL 서버 연동을 위해 임시파일  hostlist 생성
	./hosttodns.py  ### hostname을 DNS서버로 전송
	./hosttomail.py ### hostname을 MAIL서버로 전송
	if [ -f successDNS ] ### hostname이 성공적으로 전송 되었을 시 생성되는 임시 파일
	then
		echo  $TODAY  `cat hostname.tmp` "   to DNS server" >> /var/log/hostsend ### 전송된 hostname을 로그에 기록
		rm -f successDNS
	fi

	if [ -f successMAIL ]
	then
		echo  $TODAY  `cat hostname.tmp` "   to MAIL server" >> /var/log/hostsend
		rm -f successMAIL
	fi

	if [ ! -f $failDNS -a ! -f $failMAIL ]
	then
		rm -f hostname.tmp ### hostlist 삭제
		rm -f $failDNS $failMAIL 2> /dev/null
	fi
}
clear
while :
do
	#### 메뉴 출력####
	menu
	### 메뉴에 출력된 상품 선택 ###
	read -p "  입력 : " i
	case $i in
	1) ### 500MB
		casein 500M
		break;;
	2) ### 1GB
		casein 1GB
		break;;
	3) ### 3GB
		casein 3GB
		break;;
	4) ### 5GB
		casein 5GB
		break;;
	5) ### 10GB
		casein 10GB
		break;;
	6) ### 15GB
		casein 15GB
		break;;
	r)
		exit;;
	*)
		echo "숫자 1~6 중에서 선택하세요"
	esac
done
