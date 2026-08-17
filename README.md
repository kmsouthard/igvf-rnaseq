# igvf-rnaseq

Bulk RNA-seq processing for Hs27 fibroblasts, from *Comprehensive transcription factor
perturbations recapitulate fibroblast transcriptional states* (Nat Genet 2025,
[doi:10.1038/s41588-025-02284-1](https://doi.org/10.1038/s41588-025-02284-1)).

Deep polyA RNA-seq of unmodified Hs27, two biological replicates, paired-end on a
NovaSeq 6000, processed with **nf-core/rnaseq 3.14.0**. `pipeline_info/` is the run's own
samplesheet, parameters and report.

## Run

```bash
FASTA=… GTF=… ./pipeline.sh pipeline_info/samplesheet.valid.csv results/
```

Requires Nextflow and Singularity.

## Inputs

`pipeline_info/samplesheet.valid.csv` is the samplesheet as run. Strandedness is `auto`;
the pipeline inferred **reverse**, which matches the TruSeq Stranded mRNA LT prep.

The reference was a lab-local build at `/fscratch/genomes/tmn`, since deleted, passed as
explicit `--fasta` / `--gtf` with a prebuilt `--star_index` rather than through
`--genome`. Its identity survives in the outputs: **GENCODE GRCh38 primary assembly** —
`chr1`…`chrM` for the 25 primary sequences, GenBank accessions (`GL000008.2`,
`KI270379.1`) for the scaffolds. Gene IDs are versioned Ensembl, e.g.
`ENSG00000000003.15`. Full settings in `pipeline_info/params_2024-04-25_23-06-28.json`.

## Outputs

```
star_salmon/<SAMPLE>.markdup.sorted.bam          STAR genome alignments, duplicates marked
star_salmon/<SAMPLE>.markdup.sorted.bam.bai
star_salmon/bigwig/<SAMPLE>.forward.bigWig       raw coverage, plus-strand transcripts
star_salmon/bigwig/<SAMPLE>.reverse.bigWig       raw coverage, minus-strand transcripts
star_salmon/salmon.merged.gene_tpm.tsv           length- and depth-corrected
star_salmon/salmon.merged.gene_counts.tsv        estimated counts, for differential testing
```

The library is reverse-stranded, so the `forward` track carries reads from transcripts
on the plus strand. Coverage is unnormalized read depth — the stored values are exact
integers, scale factor 1.

## Versions

`software_versions.csv`. The run has no `software_versions.yml`: it stopped at
`QUALIMAP_RNASEQ`, which exceeded an 8 h limit, and nf-core writes that manifest only on
completion. Qualimap is pure QC, so the alignment, quantification and coverage outputs
above are unaffected — but the versions had to come from each tool's own output instead.

| Tool | Version | Read from |
|---|---|---|
| nf-core/rnaseq | 3.14.0-gb89fac3 | `pipeline_report.txt` |
| Nextflow | 23.04.1 | `pipeline_report.txt` |
| STAR | **2.6.1d** | `star_salmon/log/*.Log.out` banner |
| Salmon | 1.10.1 | `aux_info/meta_info.json` |
| BEDTools | 2.30.0 | not confirmed against the run |
| Trim Galore!, Picard, samtools, UCSC bedClip / bedGraphToBigWig | — | processes appear in `execution_trace…txt`; versions not recorded |

STAR 2.6.1d rather than the 2.7.x that nf-core 3.14.0 normally ships, because the
alignment ran through `STAR_ALIGN_IGENOMES`, which pins the older binary for prebuilt
iGenomes-style indices. The process name is in the execution trace.

## Data

IGVF Data Portal, analysis set
[IGVFDS7222ZXXW](https://data.igvf.org/analysis-sets/IGVFDS7222ZXXW/) — the BAMs,
indexes, stranded bigWigs and the two merged Salmon tables. Its inputs are measurement
sets [IGVFDS9984RFAZ](https://data.igvf.org/measurement-sets/IGVFDS9984RFAZ/) and
[IGVFDS7058GJAW](https://data.igvf.org/measurement-sets/IGVFDS7058GJAW/).

These records are `in progress`, so the links resolve only for signed-in submitters
until release.

## Related

* Pipeline: [nf-core/rnaseq](https://github.com/nf-core/rnaseq/releases/tag/3.14.0) 3.14.0
* [kmsouthard/igvf-cutrun](https://github.com/kmsouthard/igvf-cutrun) ·
  [kmsouthard/igvf-atac](https://github.com/kmsouthard/igvf-atac) ·
  [kmsouthard/igvf-crispra](https://github.com/kmsouthard/igvf-crispra)
