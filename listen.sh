#!/usr/bin/env bash

nc -lu 19252 | tee -a rawlog.json | tee /dev/stderr | python log_local.py | tee -a temperature.csv