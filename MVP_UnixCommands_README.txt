##ADDITIONAL README
#This file contains snippets of Unix command-line codes that were utilized to process MVP data

#Finding additional RDB scores by rsID using downloaded .tsv file
awk 'NR==FNR {ids[$1]; next} $4 in ids' initial_missing_rdb_snps.txt ENCFF250UJY_RDBScoresMAF01.tsv > matched_rsids.tsv && awk '{OFS=FS="\t"} FNR==1 {print "rsid\tranking"; print $4, $5} FNR >1 {print $4, $5}' matched_rsids.tsv > missing_rdb_scores.txt

#Finding allele frequencies using 1000Genomes data - final version
vcftools --gzvcf freq.vcf.gz --snps combined_snplist.txt --stdout --recode | awk '{FS=OFS="\t"} FNR>9 {print $0}' > genereg_snps_freq.txt

#Finding a list of rsIDs in the expanded SNP database for supplemental data
grep -F -f genic_snplist.txt SNPsbylocus_combined_expanded.txt > genic_temp.txt && (head -n 1 SNPsbylocus_combined_expanded.txt; cat genic_temp.txt) > genic_snps_data.txt