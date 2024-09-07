# access
ssh BCG2023_dmontero-rasgado@159.149.160.7

# password
MNTDCM98B66Z514H

# 1) after downloading the files I want to upload them in the server

scp -r /home/dulma/Documents/Epigenomics/HepG2_chromHMM_18states_hg38.bed BCG2023_dmontero-rasgado@159.149.160.7:~/CREB3/


# DONE!
mv rep2.bam rep1.bam control.bam GRCh38_unified_blacklist.bed Epigenomics/CREB3_project/



### RUN FROM HERE IF YOU WANNA DO IT AGAIN

# 2) samtools to compute mapping statistics - flagstat

# first give a look at how your files look like
samtools view -h -n 5 rep1.bam
#### then compute the mapping stats | good enough quality? unique over 90%?


#% of mapped reads in each of the ChIP replicates BEFORE FILTERING
samtools flagstat CREB3_rep1.bam  # 96.72%   good quality 
samtools flagstat CREB3_rep2.bam # 96.36%

#% of mapped reads in the input
samtools flagstat CREB3_control.bam  # 81.69% check this!!




######### filtering and naming it after filter
# > means save results in a file
# filter for delete low quality DONEEE


samtools view -bq 1 CREB3_rep1.bam > filtered_CREB_rep1.bam
samtools view -bq 1 CREB3_rep2.bam > filtered_CREB_rep2.bam 
samtools view -bq 1 CREB3_control.bam > filtered_CREB_control.bam

# 1 because we remove multiple mapped seqs DONEEE



########## calculate the % of non unique read mapping DONE
# before, 
# we are using view
# every read has flags option -F or -F
# we want to select those that contain mapped flags
# we also want to count -c
# -f keep -F exclude
# -f 4 keep all with flag 4

# samtools view -c -f

# then we wanna find the flag for each segment properly aligned according to the aligner
# bam file flags
# option 2 for keeping the good ones, option 4 for deleting the bad ones. remember we just have 1,2,4 options in our case (check your data)
# mapped normally = 2, no more flags, no duplicates, no secondary no anything
# this gives a single number 

# samtools view -c -f 2 filtered_CREB_rep1.bam  #number of unique map reads
# they shoudl give me the same result, better remove the bad ones



# AFTER filtering, % of multi-mapping reads in both the ChIP replicates and the input
samtools view -c -F 4 filtered_CREB_rep1.bam # 32169584
samtools view -c -F 4 filtered_CREB_rep2.bam # 32563350
samtools view -c -F 4 filtered_CREB_control.bam  # 41348490

# PERCENTAGE OF MULTI-MAPPING READS (READS LOST)

# for CREB3_rep1
#Percent of multi-mapping reads lost: 5.11%

# for CREB3_rep2
# Percent of multi-mapping reads lost for CREB3_rep2.bam: 5.60%

# for CREB3_control
# Percent of multi-mapping reads lost for CREB3_control.bam: 26.86%



###################### PERCENTAGE OF UNIQUE MAPPED READS

# now we divide this number by the previos one
[that number] / unfiltered mapped reads

# this needs to be over 70-75% (after filtering)
# PMR before filtering should be over 80%

# counting how many reads do we have before

samtools view -c filtered_CREB_rep1.bam # 32169584
samtools view -c filtered_CREB_rep2.bam # 32563350
samtools view -c filtered_CREB_control.bam # 41348490

# rep1
# total tags in treatment: 32169584
# tags after filtering in treatment: 30255409




###################### CALL PEAKS  	DONE!!
# 3) macs2 | adding my own quality check -q 0.01 (not mandatory), maybe changing it to 0.08


# ---- few peaks detected :(
macs2 callpeak -t filtered_CREB_rep1.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep1 

macs2 callpeak -t filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep2

macs2 callpeak -t filtered_CREB_rep1.bam filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_merged




##-- setting q at 0.08 and disabling dynamic peak size estimation
# ERANDHI DONE

macs2 callpeak -t filtered_CREB_rep1.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep1 --qvalue 0.08 --nomodel

macs2 callpeak -t filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_rep2 --qvalue 0.08 --nomodel

macs2 callpeak -t filtered_CREB_rep1.bam filtered_CREB_rep2.bam -c filtered_CREB_control.bam -g hs -n CREB3_merged --qvalue 0.08 --nomodel





# this gives you many different files! so now need to see which one you are gonna use

####File Details Recap first peak call with few reads
CREB3_rep1_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 109 bps

CREB3_rep2_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 123 bps


#### ERANDHI DONE
#### File details recap second peak call
CREB3_rep1_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 200 bps

CREB3_rep2_peaks.xls
Redundant Rate in Treatment: 0.06
Redundant Rate in Control: 0.04
Fragment Size: 200 bps




#####################################################

# uploading the balcklist to the server DONE
GRCh38_unified_blacklist.bed

# DONE
scp -r /home/dulma/Documents/Epigenomics/CREB3/GRCh38_unified_blacklist.bed BCG2023_dmontero-rasgado@159.149.160.7:~/CREB3/

# DONE
ENCODE.bed.gz
scp -r /home/dulma/Documents/Epigenomics/CREB3/ENCODE.bed.gz BCG2023_dmontero-rasgado@159.149.160.7:~/CREB3/



###################### 4) remove the black listed regions

# these are weird regions
# We want to compare two files!
#-v  # intersect

# Check the name of the files that are gonna be created after that command, you need to look for the ones that are _summits.bed      and work with them!!

# examples of what you should get:
# CREB3_rep1_peaks.narrowPeak
# CREB3_rep1_peaks.broadPeak (if broad peak calling is enabled)
# CREB3_rep1_summits.bed  ********* this is what we are gonna use
# CREB3_rep1_peaks.xls
# CREB3_rep1_control_lambda.bdg
# CREB3_rep1_treat_pileup.bdg
# CREB3_rep1_peaks.log

#### REMEMBER THE PREFIX SELECTED in the last step:
# CREB3_rep1
# CREB3_rep2
# CREB3_merged

# blacklist name: GRCh38_unified_blacklist.bed


## FINAL PEAKS
#### REMOVING BLACKLIST REGIONS   erandhi do from here
# So you should do something like this:

bedtools intersect -v -a CREB3_rep1_summits.bed -b GRCh38_unified_blacklist.bed > filtered_rep1_summits.bed
# 5608 filtered_rep1_summits.bed

bedtools intersect -v -a CREB3_rep2_summits.bed -b GRCh38_unified_blacklist.bed > filtered_rep2_summits.bed
# 7027 filtered_rep2_summits.bed

bedtools intersect -v -a CREB3_merged_summits.bed -b GRCh38_unified_blacklist.bed > filtered_merged_summits.bed
# 3743 filtered_merged_summits.bed before adjusting
# 6232 filtered_merged_summits.bed now!





###################   5) Compute the common peaks between the two replicates  ERANDHI DONE

# here we create a 4th file with all the peaks in common between rep1 and rep2
# so just two lines of code!
# when you use bedtools closest gives you one line for each file
#one to keep peaks for rep1 and another for rep2


bedtools closest -a filtered_rep1_summits.bed -b filtered_rep2_summits.bed -d -t first| awk '{if ($11 >= 0 && $11 <= 100) print }' | cut -f1-5 > rep1_rep2_filtered100.bed

bedtools closest -a filtered_rep2_summits.bed -b filtered_rep1_summits.bed -d -t first| awk '{if ($11 >= 0 && $11 <= 100) print }' | cut -f1-5 > rep2_rep1_filtered100.bed


### Count the number of peaks in common
num_common_peaks_rep1=$(wc -l < rep1_rep2_filtered100.bed)
num_common_peaks_rep2=$(wc -l < rep2_rep1_filtered100.bed)

echo "Number of common peaks (rep1 to rep2): $num_common_peaks_rep1"
#####Number of common peaks (rep1 to rep2): 1870
##----Number of common peaks (rep1 to rep2): 2762 ERANDHI


echo "Number of common peaks (rep2 to rep1): $num_common_peaks_rep2"
######Number of common peaks (rep2 to rep1): 1870
##----Number of common peaks (rep2 to rep1): 2762 ERANDHI


## now getting the PERCENTAGE
# Count total peaks in replicate 1 (before filtered100) : 5608

# Count total peaks in replicate 2 (before filtered100): 7027


	### percentage
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


# ignore
scp BCG2023_dmontero-rasgado@159.149.160.7:~/CREB3/CREB3_merged_model.pdf /home/dulma/Documents/Epigenomics/




##############   6) Compute the number of peaks in common between replicates and ENCODE:

# to see if you can compare your results with ENCODE
# try to figure out where to get the ENCODE file LOL and then create a summit file for itS

#### TOTAL PEAKS IN THE ENCODE FILE
# 7476 encode_summits.bed



### 6.1 CREATE THE summit file for ENCODE

# create a summit file for ENCODE, I just one the individual location at the single bp

#First sort ENCODE file:  	# DONE 
#awk '{OFS="\t"; print $1, $2+$10, $2+$10}' ENCODE.bed.gz| bedtools sort -i > encode_summits.bed

zcat ENCODE.bed.gz | awk 'BEGIN{OFS="\t"} {print $1, $2+$10, $2+$10}' | bedtools sort -i - > encode_summits.bed



####### for each replicate how many peaks in common are in your replicate and the other replicate2 since they are two diff files
# how many peaks we identify as common btwn the two
 
 ERANDHI DO

1. each replicate 

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




#### 2. common between replicates DONE

# joint summits of both rep1 and rep2
bedtools closest -a rep1_rep2_filtered100.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > rep1_rep2_encode_summits.bed
#- 26959 out of 38556

bedtools closest -a rep2_rep1_filtered100.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > rep2_rep1_encode_summits.bed
#-26890 out of 38557




#### 3. merged replicates   DONE
bedtools closest -a filtered_merged_summits.bed -b encode_summits.bed -d -t first| awk '{if ($9 >= 0 && $9 <= 100) print }' | cut -f1-5 > merged_encode_summits.bed
#- 31563 out of 82294




############## 7) how many reads I removed?
# for each file count the num. of peaks that are kept

wc -l rep2_encode_summits.bed
# 1855 rep2_encode_summits.bed


# Count how many peaks are kept
# similar to Isabella's check


################## 8) Boxplot of q-values between replicates and ENCODE:
# create a file with all the peaks that are not in common with ENCODE, the news that you identified! this is done cause we are gonna compare the q values between the ones that are in common with ENCODE and the ones that are not in common with ENCODE

bedtools intersect -v -a filtered_rep1_summits.bed -b rep1_encode_summits.bed > non_rep1_summits.bed

bedtools intersect -v -a filtered_rep2_summits.bed -b rep2_encode_summits.bed > non_rep2_summits.bed

bedtools intersect -v -a rep1_rep2_filtered100.bed -b rep1_rep2_encode_summits.bed > non_rep1_rep2_summits.bed

bedtools intersect -v -a rep2_rep1_filtered100.bed -b rep2_rep1_encode_summits.bed > non_rep2_rep1_summits.bed

bedtools intersect -v -a filtered_merged_summits.bed -b merged_encode_summits.bed > non_merged.bed




9) LAST STEP

# Decide on final sample to use with Jaccard index:

zcat ENCODE.bed.gz | bedtools sort -i - > sorted_encode.narrowPeak


bedtools intersect -wa -a CREB3_rep1_peaks.narrowPeak -b rep1_rep2_encode_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
#206093	3414493	0.0603583	1039
#-0.502532 (ignore this number)



bedtools intersect -wa -a CREB3_rep2_peaks.narrowPeak -b rep2_rep1_encode_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
255581	3419839	0.0747348	1045
#-0.499144



bedtools intersect -wa -a CREB3_merged_peaks.narrowPeak -b filtered_merged_summits.bed | bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
386221	3763626	0.102619	1941
#-0.306252



######### compute the jaccard index

bedtools intersect -wa -a CREB3_rep1_peaks.narrowPeak -b filtered_rep1_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
333972	3748711	0.0890898	1763


bedtools intersect -wa -a CREB3_rep2_peaks.narrowPeak -b filtered_rep2_summits.bed| bedtools jaccard -a - -b sorted_encode.narrowPeak
#intersection	union	jaccard	n_intersections
504610	4007391	0.12592	2315
### this one



############ Choose file with highest jaccard similarity

#bedtools intersect -a chosen_file -b HepG2_chromHMM_18states_hg38.bed  -wa -wb | cut -f 1-5,9 > chromHMM_peaks.bed

bedtools intersect -a CREB3_rep2_peaks.narrowPeak -b HepG2_chromHMM_18states_hg38.bed -wa -wb | cut -f 1-5,9 > chromHMM_peaks.bed

#HepG2_chromHMM_18states_hg38.bed


# If you choose the common peaks file (rep1_rep2 or rep2_rep1):
bedtools intersect -wa -a CREB3_rep1_peaks.narrowPeak -b rep1_rep2_encode_summits.bed > final.narrowPeak





# Now let's run the R code!






















