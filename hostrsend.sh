#!/bin/sh
### hostname 재전송 스크립트 ###
failDNS='You_Must_RESEND_hostname.tmp_To_DNSserver'
failMAIL='You_Must_RESEND_hostname.tmp_To_MAILserver'
TODAY=$(date +%Y%m%d%H%M)

if [ ! -f hostname.tmp ]
then
	if [ -f $failDNS -o -f $failMAIL ]
	then
		echo "hostname.tmp 파일을 찾을 수 없습니다"
		echo "전송을 중단합니다"
	else
		echo "재전송이 필요한 hostname이 없습니다"
	fi
else

	if [ -f $failDNS ]
	then
		echo "hostname을 네임 서버에 재전송합니다"
		./hosttodns.py
		if [ -f successDNS ]
		then
			
			echo  $TODAY  `cat hostname.tmp` "   to DNS server (retried)" >> /var/log/hostsend
			rm -f successDNS
			rm -f $failDNS
		fi
	fi

	if [ -f $failMAIL ]
	then
		echo "hostname을 메일 서버에 재전송합니다"
		./hosttomail.py
		if [ -f successMAIL ]
		then
			echo  $TODAY  `cat hostname.tmp` "   to MAIL server (retried)" >> /var/log/hostsend
			rm -f successMAIL
			rm -f $failMAIL
		fi
	fi

	if [ ! -f $failDNS -a ! -f $failMAIL ]
	then
		rm -f hostname.tmp	
	fi
fi
