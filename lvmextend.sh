#!/bin/sh
### 상품 변경 메뉴 출력 ###
menu()
{
    echo ' ===================================== '
    echo '  변경된 상품을 선택해주시기 바랍니다. '
    echo ' ===================================== '
    echo '  1)    500MB'
    echo '  2)    1GB'
    echo '  3)    2GB'
    echo '  4)    5GB'
    echo '  5)    10GB'
    echo '  6)    15GB'
	echo '  r)    돌아가기'
}
### 논리 볼륨 용량 수정 ###
### 사용법 : lvmext 추가할용량
lvmext()
{
	lvextend -L $1 /dev/HOSTING/$hostname ### 받은 인자에 따라 용량 수정
	resize2fs /dev/HOSTING/$hostname ### OS에 파티션 용량이 바뀐것을 알려줌
	echo "===== 용량 추가 완료 ====="
}

### 유저 검색 ###
while :
do
	read -p "호스트명을 입력하세요 (돌아가기 : r) : " hostname
	if [ $hostname == "r" ] ### 'r'을 입력할 시 스크립트 종료
	then
		exit
	elif [ ! -d /home/$hostname ] ### 호스트명 존재유무 확인
	then
		echo "존재하지 않는 호스트입니다. 다시 확인하세요."
	else
		break ### 호스트명이 존재할 시 while문 종료
	fi
done
### 메뉴 출력 ###
clear
menu
### 메뉴 선택 ###
read -p "선택 :  " exten
while :
do
	case $exten in
	1)
		lvmext 500M
		break;;
	2)
		lvmext 1G
		break;;
	3)
		lvmext 3G
		break;;
	4)
		lvmext 5G
		break;;
	5)
		lvmext 10G
		break;;
	6)
		lvmext 15G
		break;;
	r)
		exit;;
	*)
		echo "숫자 1-6 사이에 입력해주세요."
	esac
done

