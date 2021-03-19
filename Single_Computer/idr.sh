#!/bin/bash
# 1 sample 2 sample 3 name 4 cut-off
echo $1
echo $2
echo $3
echo $4
idr --samples $1 $2 \
--input-file-type narrowPeak \
--output-file $3 \
--idr-threshold $4
