###### 4. ACCARD INDEX

# Decide on final sample to use with Jaccard index:
zcat ENCODE.bed.gz | bedtools sort -i - > sorted_encode.narrowPeak


bedtools intersect -wa -a CREB3_rep1_peaks.narrowPeak -b rep1_rep2_encode_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
bedtools intersect -wa -a CREB3_rep2_peaks.narrowPeak -b rep2_rep1_encode_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
bedtools intersect -wa -a CREB3_merged_peaks.narrowPeak -b filtered_merged_summits.bed | bedtools jaccard -a - -b sorted_encode.narrowPeak


######## COMPUTE THE JACCARD INDEX

bedtools intersect -wa -a CREB3_rep1_peaks.narrowPeak -b filtered_rep1_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
333972	3748711	0.0890898	1763


bedtools intersect -wa -a CREB3_rep2_peaks.narrowPeak -b filtered_rep2_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
504610	4007391	0.12592	2315
### this one


######### CHOOSING THE FILE WITH THE HIGHEST JACCARD SIMILARITY

bedtools intersect -a CREB3_rep2_peaks.narrowPeak -b HepG2_chromHMM_18states_hg38.bed -wa -wb | cut -f 1-5,9 > chromHMM_peaks.bed

# If you choose the common peaks file (rep1_rep2 or rep2_rep1):
bedtools intersect -wa -a CREB3_rep1_peaks.narrowPeak -b rep1_rep2_encode_summits.bed > final.narrowPeak

# now run the R code