# igvf-rnaseq

Bulk RNA-seq processing for Hs27 fibroblasts and hTERT RPE-1 cells, from
*Comprehensive transcription factor perturbations recapitulate fibroblast
transcriptional states* (Nat Genet 2025,
[doi:10.1038/s41588-025-02284-1](https://doi.org/10.1038/s41588-025-02284-1)).

Deep polyA RNA-seq of unmodified cells, two biological replicates per line,
paired-end on a NovaSeq 6000, processed with **nf-core/rnaseq 3.12.0**.

The nf-core version is on record. The reference arguments and the original run
directory are not, so `pipeline.sh` and `samplesheet.csv` here are reconstructed from
the deposited files and should be replaced if the original run is located.

## Run

```bash
FASTA=GRCh38.primary_assembly.genome.fa GTF=gencode.annotation.gtf \
  ./pipeline.sh samplesheet.csv results/
```

Requires Nextflow and Singularity. Library prep is TruSeq Stranded mRNA LT, which is
reverse-stranded — hence `strandedness: reverse` in the samplesheet.

## Inputs

`samplesheet.csv` lists one row per library. FASTQ paths are placeholders; raw reads are
at SRA [PRJNA1108254](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1108254).

The reference is **GENCODE GRCh38 primary assembly**, read off the deposited bigWigs:
`chr1`…`chrM` for the 25 primary sequences and GenBank accessions (`GL000008.2`,
`KI270379.1`) for the 54–58 scaffolds. Gene IDs in the output are versioned Ensembl,
e.g. `ENSG00000000003.15`. This is why `--fasta`/`--gtf` are passed explicitly rather
than `--genome GRCh38`, whose iGenomes reference is Ensembl-named (`1`, `2`, `MT`). The
exact GENCODE release is not recorded.

## Outputs

```
star_salmon/<SAMPLE>.markdup.sorted.bam          STAR genome alignments, duplicates marked
star_salmon/<SAMPLE>.markdup.sorted.bam.bai
star_salmon/bigwig/<SAMPLE>.forward.bigWig       unnormalized coverage, plus-strand transcripts
star_salmon/bigwig/<SAMPLE>.reverse.bigWig       unnormalized coverage, minus-strand transcripts
star_salmon/salmon.merged.gene_tpm.tsv           length- and depth-corrected
star_salmon/salmon.merged.gene_counts.tsv        estimated counts, for differential testing
```

Because the library is reverse-stranded, the `forward` track carries reads from
transcripts on the plus strand. Coverage is raw read depth — the values are exact
integers, no scale factor applied.

`software_versions.csv` records the versions of the run that produced the deposited
files.

## Related

* Pipeline: [nf-core/rnaseq](https://github.com/nf-core/rnaseq/releases/tag/3.12.0) 3.12.0
* [kmsouthard/igvf-cutrun](https://github.com/kmsouthard/igvf-cutrun) ·
  [kmsouthard/igvf-atac](https://github.com/kmsouthard/igvf-atac) ·
  [kmsouthard/igvf-crispra](https://github.com/kmsouthard/igvf-crispra)
