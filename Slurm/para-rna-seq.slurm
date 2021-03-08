#!/bin/bash

for fq in `ls -1 *.fastq.gz | sed 's/.fastq.gz//'`
do
  echo "running analysis on $fq"
  sbatch --time=01:00:00 --mem=48G --job-name Zipline-rna-seq --wrap "/home/rcf-proj/zl1/bin/para-rna-seq.sh $fq"
done
