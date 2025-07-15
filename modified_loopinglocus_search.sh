#!/bin/bash

# Check if the file argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <loci_of_interest_file>"
  exit 1
fi

loci_file=$1

# Check if the loci file exists and is readable
if [ ! -f "$loci_file" ]; then
  echo "Error: File $loci_file does not exist or is not readable."
  exit 1
fi

while IFS=$’\t’ read -r line
do

IFS=$'\t' read -r chr start end <<< "$line"

echo "Processing region: ${chr}:${start}-${end}"

url=ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000_genomes_project/release/20190312_biallelic_SNV_and_INDEL/ALL.chr${chr}.shapeit2_integrated_snvindels_v2a_27022019.GRCh38.phased.vcf.gz

bcftools view -r ${chr}:${start}-${end} ${url} -o ${chr}_${start}_${end}.vcf.gz

# Check if the VCF file is empty (no variants)
if [ ! -s ${chr}_${start}_${end}.vcf.gz ]; then
    echo "No variants found for ${chr}:${start}-${end}. Skipping..."
    # Skip the current iteration if the file is empty
    continue
fi

plink --vcf ${chr}_${start}_${end}.vcf.gz --make-bed --out 1000G_MVP_SNPslist_${chr}_${start}_${end}

done < "$loci_file"