#!/bin/bash
#SBATCH --time=15:00:00
#SBATCH --mem=30GB
source /home/rcf-proj/pjf/zhifeilu/miniconda3/etc/profile.d/conda.sh
conda activate z
#mkdir fastq trim qc bam track
n=`nproc`
dir=`pwd`
#=================================
#Read alignment
#cd ${dir}/fastq
for i in ${1}*_R1.trim.fastq.gz; do
[ -e "$i" ] || continue
base=${i%_R1.trim.fastq.gz}
#alignment
bwa mem -t $n /home/rcf-proj/zl1/refs/hg38/bwa/hg38 <( zcat ${base}_R1.trim.fastq.gz) <(zcat ${base}_R2.trim.fastq.gz) | samblaster 2> ${base}.dup.qc | samtools view -Su - | sambamba sort -o ${base}.mark.bam /dev/stdin
#generate sorted bam file
sambamba view -t $n -h -f bam -F "not (supplementary or secondary_alignment or unmapped or duplicate) and proper_pair and mapping_quality>=30" ${base}.mark.bam > ${base}.filt.bam
sambamba index -t $n ${base}.filt.bam
sambamba flagstat -t $n ${base}.mark.bam > ${base}.before.flagstat
sambamba flagstat -t $n ${base}.filt.bam > ${base}.flagstat
rm ${base}.sort.bam* ${base}.unsort.bam
bamCoverage -b ${base}.filt.bam -o ${base}.bigwig -of bigwig --binSize 10 -p $n \
	--ignoreForNormalization chrX chrM \
	-bl /home/rcf-proj/zl1/refs/hg38/hg38.blacklist.bed \
	--effectiveGenomeSize 2913022398 \
	--extendReads --normalizeUsing RPGC
done
#mv *trim.fastq.gz trim
#mv *fastq.gz fastq
#mv *.bam *.bam.bai bam
#mv *bigwig track
#mv *flagstat *.qc qc
#rm *mark*
