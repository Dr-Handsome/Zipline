#!/bin/bash
for fq in `ls -1 *_R1.fastq.gz | sed 's/_R1.fastq.gz//'`
do
  echo "running analysis on $fq"
  sbatch --time=05:00:00 --mem=48G --job-name Zipline-chip-seq --wrap "/home/rcf-proj/zl1/bin/para-chip-seq-pe.sh $fq"
done
