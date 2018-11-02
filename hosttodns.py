#!/usr/bin/env python
#-*- coding:utf-8 -*-

import socket
import os

### host에 네임서버 주소를 넣을 것, default port = 8888
host = "192.168.8.156"
port = 8888

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)

try :
	s.connect((host,port))

	f = open('hostname.tmp', 'r')

	for i in f.readlines() :
		s.send(i)
	print("[OK]hostname DNS 서버 전송 완료 ")
	os.system("touch successDNS") ## hostlist를 성공적으로 보낼 시 쉘스크립트에 성공을 알리기 위한 인자로써 success 파일 생성
	f.close()
	s.close()

except :
	os.system("touch You_Must_RESEND_hostname.tmp_To_DNSserver")
	print("[Err]hostname 전송 실패 :: DNS서버에 접속할 수 없습니다")
	print("DNS 서버 관리자에게 문의주시기 바랍니다")
	print("hostname 재전송에 대해선 도움말을 참고하시기 바랍니다") 
