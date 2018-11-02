#!/usr/bin/env python
#-*- coding:utf-8 -*-
### hostname 자동 접속 소켓 프로그램
### 본 파일을 항상 백그라운드로 실행할것
import socket
import os

host = ""
port = 9999

while True:
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
	s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	s.bind((host,port))
	s.listen(5)
	conn, addr = s.accept()

	f = open('/root/hostlist', 'a')

	lines = conn.recv(1024)
	f.write(lines)
	f.close()
	conn.close()
