#!/usr/bin/env bash
#
# Bulk RNA-seq: FASTQ to STAR alignments, stranded coverage and salmon quantifications.
#
# The nf-core version is recorded (3.12.0); the reference arguments are not, and
# are inferred from the deposited files. See README.
#
#     ./pipeline.sh samplesheet.csv results/
#
set -euo pipefail

SAMPLESHEET=${1:-samplesheet.csv}
OUTDIR=${2:-results}

# GENCODE GRCh38 primary assembly -- chr1..chrM plus GenBank-named scaffolds,
# which is what the deposited bigWigs contain. NOT --genome GRCh38, whose
# iGenomes reference is Ensembl-named (1, 2, MT).
FASTA=${FASTA:?path to GRCh38.primary_assembly.genome.fa}
GTF=${GTF:?path to the matching GENCODE annotation gtf}

nextflow run nf-core/rnaseq \
    -r 3.12.0 \
    --input "$SAMPLESHEET" \
    --outdir "$OUTDIR" \
    --fasta "$FASTA" \
    --gtf "$GTF" \
    -profile singularity

#   $OUTDIR/star_salmon/<SAMPLE>.markdup.sorted.bam
#   $OUTDIR/star_salmon/<SAMPLE>.markdup.sorted.bam.bai
#   $OUTDIR/star_salmon/bigwig/<SAMPLE>.forward.bigWig
#   $OUTDIR/star_salmon/bigwig/<SAMPLE>.reverse.bigWig
#   $OUTDIR/star_salmon/salmon.merged.gene_tpm.tsv
#   $OUTDIR/star_salmon/salmon.merged.gene_counts.tsv
