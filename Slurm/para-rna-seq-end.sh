#!/bin/bash
for i in *.txt; do 
cut -f 7 $i > ${i}.tmp
done
cut -f 1 `ls *.txt | head -n 1` > 1.ttmp
paste 1.ttmp *.tmp | sed '1d' > count.all.txt
rm 1.ttmp *.tmp
cd TPM
for i in *.txt; do
cut -f 7 $i > ${i}.tmp
done
cut -f 1 `ls *.txt | head -n 1` > 1.ttmp
paste 1.ttmp *.tmp  > count.all.tpm.txt
rm 1.ttmp *.tmp
cd ../..
tail -n 100 alignment/*Log.final.out > reports/alignment.report.txt
tail -n 100 counts/*report > reports/counts.report.txt
tail -n 100 trim/*trim.txt > reports/trim.report.txt
tail -n 100 counts/*summary > reports/counts.summary.report.txt
