#!/bin/bash

# adds up to 100 SNPs to a ~770 kb region around the LARGE gene
# requires samtools/bcftools

REF=../test_data/Homo_sapiens_chr22_assembly19.fasta

if [ ! -e $REF ]; then
  echo "can't find reference .fasta: $REF, please supply a bwa-indexed .fasta"
  exit 65
fi

if [ ! -e $REF.bwt ]; then
  echo "can't find $REF.bwt: is $REF indexed with bwa?"
  exit 65
fi

python3 -O ../bin/addsv.py -v ../test_data/test_trn.txt -f ../test_data/testregion_realign.bam -r $REF -o ../test_data/testregion_trn_mut.bam --seed 1234

if [ $? -ne 0 ]; then
  echo "python3 -O ../bin/addsv.py failed."
  exit 1
else
  echo "sorting output bam..."
  samtools sort -T ../test_data/testregion_trn_mut.sorted.bam -o ../test_data/testregion_trn_mut.sorted.bam ../test_data/testregion_trn_mut.bam
  mv ../test_data/testregion_trn_mut.sorted.bam ../test_data/testregion_trn_mut.bam

  echo "indexing output bam..."
  samtools index ../test_data/testregion_trn_mut.bam

fi
