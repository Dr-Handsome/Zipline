#!/bin/bash
#SBATCH --time=15:00:00
#SBATCH --mem=30GB
conda activate z
n=`nproc`
setting="-q 5 -l 32 -k 2 -t $n"
dir=`pwd`
#=================================
#Read alignment
cd ${dir}
for i in *${1}*fastq.gz; do
[ -e "$i" ] || continue
base=${i%.fastq.gz}
#alignment
bwa aln $setting /home/rcf-proj/zl1/refs/hg38/bwa/hg38 <( zcat ${base}.fastq.gz ) > ${base}.sai
#generate sorted bam file
bwa samse /home/rcf-proj/zl1/refs/hg38/bwa/hg38 ${base}.sai <(zcat ${i} ) | samblaster 2> ${base}.dup.qc | samtools view -Su - | sambamba sort  -o ${base}.mark.bam /dev/stdin
sambamba view -p -t $n -h -f bam -F "not (supplementary or secondary_alignment or unmapped or duplicate) and mapping_quality>=30" ${base}.mark.bam > ${base}.filt.bam
sambamba index -t $n ${base}.filt.bam
sambamba flagstat -t $n ${base}.mark.bam > ${base}.before.flagstat
sambamba flagstat -t $n ${base}.filt.bam > ${base}.flagstat
#rm ${base}.filt.bam
bamCoverage -b ${base}.filt.bam -o ${base}.bigwig -of bigwig --binSize 10 -p $n \
	--ignoreForNormalization chrX chrM \
	-bl /home/rcf-proj/zl1/refs/hg38/hg38.blacklist.bed \
	--effectiveGenomeSize 2913022398 \
	--extendReads 300 --normalizeUsing RPGC
done
mkdir bam qc peaks fastq
mv *fastq.gz fastq
mv *.bam *.bam.bai bam
mv *bigwig track
mv *flagstat *.qc qc
rm *mark*
