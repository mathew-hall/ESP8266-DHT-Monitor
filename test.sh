#!/usr/bin/env bash
set -x

test -f test.csv && rm test.csv
./listen.sh test.csv &
PID=$!

# Send a few recorded messages
nc -u -w5 localhost 19252 < testlog.json

#Should see some output and results in temperature.csv
kill -INT $PID

if [ $(wc -l  < testlog.json) -ne $(wc -l < test.csv) ]; then
    echo FAIL: expecting $(wc -l < testlog.json) lines in output but got $(wc -l < test.csv)
    exit -1
else
    echo Tests passed OK
    exit 0
fi