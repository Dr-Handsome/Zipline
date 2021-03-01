#!/bin/bash
# 1 sample 2 input 3 output
echo $1
echo $2
echo $3
for i in ${1}*filt.bam; do
[ -e "$i" ] || continue
base=${i%.filt.bam}
macs2 callpeak -t $i \
        -c $2 \
        -f BAM -g 2913022398 \
        -n ${base}.p001 \
	-p 0.01	\
        --outdir $3 --keep-dup all
done

#--call-summits
