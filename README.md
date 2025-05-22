# CREB3 ChIP-Seq Workflow

CREB3-ChIP-Seq-Workflow is a reproducible and simple pipeline to analyze ChIP-seq data targeting the transcription factor **CREB3**. Designed for a human genome (GRCh38/hg38) context, automatized for:

<br>

**Mapping Statistics and Quality Control:** Calculates mapping quality and multi-mapping rates for ChIP and control input samples using samtools. Filters out low-quality and non-uniquely mapped reads.

**Peak Calling:** MACS2 to identify transcription factor binding sites. Multiple replicates are analyzed independently and jointly

**Blacklist Filtering:** Employs bedtools to eliminate artifactual peaks by excluding ENCODE blacklisted genomic regions, ensuring peak reliability.

**Reproducibility Assessment:** Identifies overlapping peaks between replicates within a 100 bp window to assess replicate concordance.

<br>

---

Politecnico di Milano - University of Milan
