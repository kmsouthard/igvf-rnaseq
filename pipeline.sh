#!/usr/bin/env bash
#
# Bulk RNA-seq: FASTQ to STAR alignments, stranded coverage and salmon quantifications.
#
#     ./pipeline.sh pipeline_info/samplesheet.valid.csv results/
#
set -euo pipefail

SAMPLESHEET=${1:-pipeline_info/samplesheet.valid.csv}
OUTDIR=${2:-results}

# The reference was a lab-local build at /fscratch/genomes/tmn, which no longer
# exists. Its contig naming survives in the outputs: GENCODE GRCh38 primary
# assembly, chr1..chrM plus GenBank-named scaffolds. Full settings are in
# pipeline_info/params_2024-04-25_23-06-28.json.
FASTA=${FASTA:?GENCODE GRCh38 primary assembly fasta}
GTF=${GTF:?matching GENCODE annotation gtf}
STAR_INDEX=${STAR_INDEX:-}

nextflow run nf-core/rnaseq \
    -r 3.14.0 \
    --input "$SAMPLESHEET" \
    --outdir "$OUTDIR" \
    --fasta "$FASTA" \
    --gtf "$GTF" \
    ${STAR_INDEX:+--star_index "$STAR_INDEX"} \
    --aligner star_salmon \
    --trimmer trimgalore \
    -profile singularity

#   $OUTDIR/star_salmon/<SAMPLE>.markdup.sorted.bam
#   $OUTDIR/star_salmon/<SAMPLE>.markdup.sorted.bam.bai
#   $OUTDIR/star_salmon/bigwig/<SAMPLE>.{forward,reverse}.bigWig
#   $OUTDIR/star_salmon/salmon.merged.gene_tpm.tsv
#   $OUTDIR/star_salmon/salmon.merged.gene_counts.tsv
