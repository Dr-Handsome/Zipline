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
        -n ${base} \
        --outdir $3 --keep-dup all

#macs2 callpeak -t $i \
#        -f BAM -g 2913022398 \
#        -n ${base} \
#	--broad \
#        --outdir $3 --keep-dup all

done
#awk '{if($5 >= 540) print $0}' idr.hoxc6.22rv1.narrowPeak > idr.hoxc6.22rv1..narrowPeak
