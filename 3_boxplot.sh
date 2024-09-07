######### BOXPLOT of q-values between replicates and ENCODE:
# create a file with all the peaks that are not in common with ENCODE, the news that you identified! this is done cause we are gonna compare the q values between the ones that are in common with ENCODE and the ones that are not in common with ENCODE

bedtools intersect -v -a filtered_rep1_summits.bed -b rep1_encode_summits.bed > non_rep1_summits.bed

bedtools intersect -v -a filtered_rep2_summits.bed -b rep2_encode_summits.bed > non_rep2_summits.bed

bedtools intersect -v -a rep1_rep2_filtered100.bed -b rep1_rep2_encode_summits.bed > non_rep1_rep2_summits.bed

bedtools intersect -v -a rep2_rep1_filtered100.bed -b rep2_rep1_encode_summits.bed > non_rep2_rep1_summits.bed

bedtools intersect -v -a filtered_merged_summits.bed -b merged_encode_summits.bed > non_merged.bed
