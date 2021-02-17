#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --mem=64GB
#. /home/rcf-proj/pjf/zhifeilu/miniconda3/etc/profile.d/conda.sh
#conda activate z
cd `pwd`
n=`nproc`
gtf='/home/rcf-proj/zl1/refs/hg38/gencode.v29.primary_assembly.annotation.tRNA.ercc.gtf'
star_index='/home/rcf-proj/zl1/refs/hg38/star_hg38_49_ercc'

mkdir fastq trim alignment counts reports

#trim adapters
#for i in `ls -1 *_R1.fastq.gz | sed 's/_R..fastq.gz//'`; do
#	trimmomatic PE -phred33 -threads $n ${i}_R1.fastq.gz ${i}_R2.fastq.gz ${i}_R1.trim.fastq.gz ${i}_R1.unpaired.fastq.gz ${i}_R2.trim.fastq.gz ${i}_R2.unpaired.fastq.gz ILLUMINACLIP:/home/rcf-proj/zl1/refs/adapter/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 &> ${i}.trim.txt
#done
mv *trim.fastq.gz *txt trim
mv *fastq.gz fastq
echo 'Reads trimmed'

#reads alignment
cd trim
for i in `ls -1 prec3_R1.trim.fastq.gz | sed 's/_R..trim.fastq.gz//'`; do
        STAR --runThreadN $n --genomeDir $star_index --readFilesCommand zcat --readFilesIn ${i}_R1.trim.fastq.gz ${i}_R2.trim.fastq.gz --outFileNamePrefix ${i}. \
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
done
mv *bam *tab *out ../alignment

echo 'Reads aligned'

#reads counts
cd ../alignment
for i in `ls -1 *.Aligned.sortedByCoord.out.bam | sed 's/.Aligned.sortedByCoord.out.bam//'`; do
        featureCounts -T $n -s 2 -t exon -g gene_id -a $gtf -o ${i}.txt ${i}.Aligned.sortedByCoord.out.bam &> ${i}.count.report
done
mv *report *txt *summary ../counts
echo 'Reads counted'

#compute TPM
for i in ../counts/*.txt; do
Rscript /home/rcf-proj/zl1/bin/tpm_rpkm.R $i 
done
echo 'TPM get'

#reports
cd ..
tail -n 100 alignment/*Log.final.out > reports/alignment.report.txt
tail -n 100 counts/*report > reports/counts.report.txt
tail -n 100 trim/*trim.txt > reports/trim.report.txt
tail -n 100 counts/*summary > reports/counts.summary.report.txt
echo 'All done'




 




