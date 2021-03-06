
**Gene-Set-Analysis for GWAS**.

[![GitHub Actions CI Status](https://github.com/lifebit-ai/gwasgsa/workflows/nf-core%20CI/badge.svg)](https://github.com/lifebit-ai/gwasgsa/actions)
[![GitHub Actions Linting Status](https://github.com/lifebit-ai/gwasgsa/workflows/nf-core%20linting/badge.svg)](https://github.com/lifebit-ai/gwasgsa/actions)
[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A519.10.0-brightgreen.svg)](https://www.nextflow.io/)

[![install with bioconda](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg)](http://bioconda.github.io/)
[![Docker](https://img.shields.io/docker/automated/lifebitai/gwasgsa.svg)](https://hub.docker.com/r/lifebitai/gwasgsa)

## Introduction

The pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It comes with docker containers making installation trivial and results highly reproducible.

## Quick Start

i. Install [`nextflow`](https://nf-co.re/usage/installation)

ii. Install either [`Docker`](https://docs.docker.com/engine/installation/) or [`Singularity`](https://www.sylabs.io/guides/3.0/user-guide/) for full pipeline reproducibility (please only use [`Conda`](https://conda.io/miniconda.html) as a last resort; see [docs](https://nf-co.re/usage/configuration#basic-configuration-profiles))

iii. Download the pipeline and test it on a minimal dataset with a single command

```bash
nextflow run lifebit-ai/gwasgsa -profile test,docker
```

> Please check [nf-core/configs](https://github.com/nf-core/configs#documentation) to see if a custom config file to run nf-core pipelines already exists for your Institute. If so, you can simply use `-profile <institute>` in your command. This will enable either `docker` or `singularity` and set the appropriate execution settings for your local compute environment.

iv. Start running your own analysis!

<!-- TODO nf-core: Update the default command above used to run the pipeline -->

```bash

nextflow run lifebit-ai/gwasgsa \
    -profile docker \
    --vcf_file s3://lifebit-featured-datasets/projects/gel/gel-gwas/testdata/vcfs.csv \
    --gene_loc_file testdata/NCBI37.3/NCBI37.3.gene.loc \
    --set_anot_file testdata/c2.cp.reactome.v7.1.entrez.gmt \
    --outdir results_test_vcf
```

See [usage docs](docs/usage.md) for all of the available options when running the pipeline.

## Documentation

The lifebit-ai/gwasgsa pipeline comes with documentation about the pipeline, found in the `docs/` directory:

1. [Installation](https://nf-co.re/usage/installation)
2. Pipeline configuration
    * [Local installation](https://nf-co.re/usage/local_installation)
    * [Adding your own system config](https://nf-co.re/usage/adding_own_config)
    * [Reference genomes](https://nf-co.re/usage/reference_genomes)
3. [Running the pipeline](docs/usage.md)
4. [Output and how to interpret the results](docs/output.md)
5. [Troubleshooting](https://nf-co.re/usage/troubleshooting)

## Overview

This pipeline helps to do generalised gene-set analysis of GWAS data using MAGMA. It can be used to analyse both raw genotype data (list of VCFs or PLINK output) as well as Summary-Statistics file (with SNP and p-values) from a previous GWAS or meta-analysis.

## Credits

lifebit-ai/gwasgsa was originally written by Sangram Keshari Sahu.

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

For further information or help, don't hesitate to get in touch on [Slack](https://nfcore.slack.com/channels/gwasgsa) (you can join with [this invite](https://nf-co.re/join/slack)).

## Citation

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi. -->
<!-- If you use  lifebit-ai/gwasgsa for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

You can cite the `nf-core` publication as follows:

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).  
> ReadCube: [Full Access Link](https://rdcu.be/b1GjZ)
