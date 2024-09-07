######## PEAK CALLING
# this code has two ways to do the peak calling, the normal and the Erandhi one

# with default q 0.05
macs2 callpeak -t filtered_CREB_rep1.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep1 
macs2 callpeak -t filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep2
macs2 callpeak -t filtered_CREB_rep1.bam filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_merged

# setting q at 0.08 and disabling dynamic peak size estimation (to detect more peaks)
# ERANDHI DONE
macs2 callpeak -t filtered_CREB_rep1.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep1 --qvalue 0.08 --nomodel
macs2 callpeak -t filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep2 --qvalue 0.08 --nomodel
macs2 callpeak -t filtered_CREB_rep1.bam filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_merged --qvalue 0.08 --nomodel

# this gives you many different files! so now need to see which one you are gonna use

####### File Details Recap first peak call (few reads)
CREB3_rep1_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 109 bps

CREB3_rep2_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 123 bps


#### ERANDHI recap second peak call
CREB3_rep1_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 200 bps

CREB3_rep2_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 200 bps


############ REMOVE BLACKLIST REGIONS | FINAL PEAKS | Erandhi do from here

# uploading the balcklist and other shit to the server DONE
# blacklist DONE
scp -r /home/dulma/Documents/Epigenomics/CREB3/GRCh38_unified_blacklist.bed BCG2023_dmontero-rasgado@159.149.160.7:~/CREB3/

# ENCODE.bed.gz DONE
scp -r /home/dulma/Documents/Epigenomics/CREB3/ENCODE.bed.gz BCG2023_dmontero-rasgado@159.149.160.7:~/CREB3/


# remove the black listed regions
bedtools intersect -v -a CREB3_rep1_summits.bed -b GRCh38_unified_blacklist.bed > filtered_rep1_summits.bed
# 5608 filtered_rep1_summits.bed

bedtools intersect -v -a CREB3_rep2_summits.bed -b GRCh38_unified_blacklist.bed > filtered_rep2_summits.bed
# 7027 filtered_rep2_summits.bed

bedtools intersect -v -a CREB3_merged_summits.bed -b GRCh38_unified_blacklist.bed > filtered_merged_summits.bed
# 3743 filtered_merged_summits.bed before adjusting
# 6232 filtered_merged_summits.bed now!


###################  COMMON PEAKS BETWEEN REPLICATES

bedtools closest -a filtered_rep1_summits.bed -b filtered_rep2_summits.bed -d -t first| awk '{if ($11 >= 0 && $11 <= 100) print }' | cut -f1-5 > rep1_rep2_filtered100.bed
bedtools closest -a filtered_rep2_summits.bed -b filtered_rep1_summits.bed -d -t first| awk '{if ($11 >= 0 && $11 <= 100) print }' | cut -f1-5 > rep2_rep1_filtered100.bed

# Count the number of peaks in common
num_common_peaks_rep1=$(wc -l < rep1_rep2_filtered100.bed)
num_common_peaks_rep2=$(wc -l < rep2_rep1_filtered100.bed)

echo "Number of common peaks (rep1 to rep2): $num_common_peaks_rep1"
# Number of common peaks (rep1 to rep2): 1870
# Number of common peaks (rep1 to rep2): 2762 ERANDHI

echo "Number of common peaks (rep2 to rep1): $num_common_peaks_rep2"
# Number of common peaks (rep2 to rep1): 1870
# Number of common peaks (rep2 to rep1): 2762 ERANDHI


# getting the PERCENTAGE

# Count total peaks in replicate 1 (before filtered100) : 5608
# Count total peaks in replicate 2 (before filtered100): 7027


# Calculate percentage of common peaks for replicate 1
percentage_common_rep1=$(echo "scale=2; ($num_common_peaks_rep1 / $total_peaks_rep1) * 100" | bc)

# Calculate percentage of common peaks for replicate 2
percentage_common_rep2=$(echo "scale=2; ($num_common_peaks_rep2 / $total_peaks_rep2) * 100" | bc)

	##### Print percentages
echo "Percentage of common peaks (rep1 to rep2): $percentage_common_rep1%"
#Percentage of common peaks (rep1 to rep2): 52.00%
#Percentage of common peaks (rep1 to rep2): 49.00% ERANDHI


echo "Percentage of common peaks (rep2 to rep1): $percentage_common_rep2%"
#Percentage of common peaks (rep2 to rep1): 37.00%
#Percentage of common peaks (rep2 to rep1): 39.00% ERANDHI


############ PEAKS IN COMMON BETWEEN REPLICATES AND ENCODE

# creating a summit file for ENCODE
zcat ENCODE.bed.gz | awk 'BEGIN{OFS="\t"} {print $1, $2+$10, $2+$10}' | bedtools sort -i - > encode_summits.bed

# for each replicate how many peaks in common are in your replicate and the other replicate2 since they are two diff files
# how many peaks we identify as common btwn the two

#### 1. each replicate 

# rep1 vs ENCODE
bedtools closest -a filtered_rep1_summits.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > rep1_encode_summits.bed
#29967 out of 57299
# blabla out of 3561

# rep2 vs ENCODE
bedtools closest -a filtered_rep2_summits.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > rep2_encode_summits.bed
#28668 out of 51002
# blabla out of 5033

num_common_peaks_rep1=$(wc -l < rep1_encode_summits.bed)
num_common_peaks_rep2=$(wc -l < rep2_encode_summits.bed)


#### 2. common between replicates 

# joint summits of both rep1 and rep2
bedtools closest -a rep1_rep2_filtered100.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > rep1_rep2_encode_summits.bed
#- 26959 out of 38556

bedtools closest -a rep2_rep1_filtered100.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > rep2_rep1_encode_summits.bed
#-26890 out of 38557


#### 3. merged replicates   
bedtools closest -a filtered_merged_summits.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > merged_encode_summits.bed
#- 31563 out of 82294


########### READS REMOVED
# for each file count the num. of peaks that are kept

wc -l rep2_encode_summits.bed