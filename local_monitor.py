#!/usr/bin/env python
import json
import datetime
import sys

while True:
    try:
    	data = sys.stdin.readline()
    	res = json.loads(data)
    	scale = float(res['scale'])
    	print ",".join([str(x) for x in datetime.datetime.now(), res['type'], float(res['temperature']) * scale, float(res['humidity']) * scale])
    	sys.stdout.flush()
        sys.stderr.flush()
    except:
	pass