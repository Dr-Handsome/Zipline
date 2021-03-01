#!/bin/bash
for fq in `ls -1 *.fastq.gz | sed 's/.fastq.gz//'`
do
  echo "running analysis on $fq"
  sbatch --time=02:00:00 --mem=48G --job-name Zipline-chip-seq --wrap "/home/rcf-proj/zl1/bin/para-chip-seq-se.sh $fq"
done
