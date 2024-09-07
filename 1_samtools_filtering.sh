## EPIGENOMICS PROJECT | 1st Part | SAMTOOLS
# no explanation of the code


########## MAPPING STATS 

# how your files look like
samtools view -h -n 5 rep1.bam 

#% of mapped reads in each replicate BEFORE FILTERING
# we want over 90%
samtools flagstat CREB3_rep1.bam  # 96.72%   
samtools flagstat CREB3_rep2.bam # 96.36%

# % in the input
samtools flagstat CREB3_control.bam  # 81.69% check this


########## FILTERING

# filtering and naming it after filter
samtools view -bq 1 CREB3_rep1.bam > filtered_CREB_rep1.bam
samtools view -bq 1 CREB3_rep2.bam > filtered_CREB_rep2.bam 
samtools view -bq 1 CREB3_control.bam > filtered_CREB_control.bam


########## % oOF NON UNIQUE READS MAPPED DONE
# (reads lost)

# AFTER filtering, % of multi-mapping reads
samtools view -c -F 4 filtered_CREB_rep1.bam # 32169584
samtools view -c -F 4 filtered_CREB_rep2.bam # 32563350
samtools view -c -F 4 filtered_CREB_control.bam  # 41348490


# check this, is most likely repeated
########## PERCENTAGE OF UNIQUE MAPPED READS

# counting how many reads do we have before
samtools view -c filtered_CREB_rep1.bam # 32169584
samtools view -c filtered_CREB_rep2.bam # 32563350
samtools view -c filtered_CREB_control.bam # 41348490
# rep1
# total tags in treatment: 32169584
# tags after filtering in treatment: 30255409

