#!/usr/bin/env bash

OUTPUT=${1-temperature.csv}

nc -lu 19252 | tee -a rawlog.json | python local_monitor.py | tee -a $OUTPUT