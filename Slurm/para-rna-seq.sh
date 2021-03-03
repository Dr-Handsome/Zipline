#!/bin/bash
. /home/rcf-proj/pjf/zhifeilu/miniconda3/etc/profile.d/conda.sh
conda activate z
cd `pwd`
n=`nproc`
gtf='/home/rcf-proj/zl1/refs/hg38/gencode.v29.primary_assembly.annotation.tRNA.ercc.gtf'
star_index='/home/rcf-proj/zl1/refs/hg38/star_hg38_49_ercc'

mkdir -p fastq trim alignment counts reports
i=$1

#trim adapters
	trimmomatic SE -phred33 -threads $n ${i}.fastq.gz ${i}.trim.fastq.gz ILLUMINACLIP:/home/rcf-proj/zl1/refs/adapter/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 &> ${i}.trim.txt
mv ${i}.trim.fastq.gz ${i}.trim.txt trim
mv ${i}.fastq.gz fastq
echo 'Reads trimmed'

#reads alignment
cd trim
        STAR --runThreadN $n --genomeDir $star_index --readFilesIn <(zcat ${i}.trim.fastq.gz) --outFileNamePrefix ${i}. \
	--outSAMtype BAM SortedByCoordinate \
        --outFilterType BySJout \
        --outFilterMultimapNmax 20 \
        --alignSJoverhangMin 8 \
        --alignSJDBoverhangMin 1 \
        --outFilterMismatchNmax 999 \
        --outFilterMismatchNoverReadLmax 0.04 \
        --alignIntronMin 20 \
        --alignIntronMax 1000000 \
        --alignMatesGapMax 1000000 \
        --outTmpDir $TMPDIR/${i}
mv ${i}*bam ${i}*tab ${i}*out ../alignment

echo 'Reads aligned'

#reads counts
cd ../alignment
        featureCounts -T $n -s 2 -t exon -g gene_id -a $gtf -o ${i}.txt ${i}.Aligned.sortedByCoord.out.bam &> ${i}.count.report
mv ${i}*report ${i}*txt ${i}*summary ../counts
echo 'Reads counted'

#compute TPM
conda deactivate
cd ../counts
Rscript /home/rcf-proj/zl1/bin/tpm_rpkm.R $i 
mkdir TPM
mv *tpm.txt TPM 
echo 'TPM get'
