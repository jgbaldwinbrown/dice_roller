#!/bin/bash
set -e

time (echo -e "1000000d5\nq" | ./roll)
time ./roll.py 1000000 5

time (cat test.txt | ./roll)
time ./roll.py 10000000 5
