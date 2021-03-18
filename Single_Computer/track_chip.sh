#!/bin/bash
#SBATCH --time=15:00:00
#SBATCH --mem=30GB
n=`nproc`
dir=`pwd`
#=================================
cd ${dir}
for i in *${1}*.filt.bam ; do
[ -e "$i" ] || continue
base=${i%.filt.bam}
bamCoverage -b ${base}.filt.bam -o ${base}.bigwig -of bigwig --binSize 10 -p $n \
        --ignoreForNormalization chrX chrM \
        -bl /home/rcf-proj/zl1/refs/hg38/hg38.blacklist.bed \
        --effectiveGenomeSize 2913022398 \
        --extendReads --normalizeUsing RPGC
done
