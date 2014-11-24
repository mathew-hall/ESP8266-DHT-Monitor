import socket
import json
import datetime

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("0.0.0.0",19252))

while True:
	data, addr = sock.recvfrom(1024)
	res = json.loads(data)
	scale = float(res['scale'])
	print datetime.datetime.now(), res['type'], float(res['temperature']) * scale, float(res['humidity']) * scale