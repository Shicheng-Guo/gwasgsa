# nf-core/gwasgsa: Usage

## Table of contents

- [nf-core/gwasgsa: Usage](#nf-coregwasgsa-usage)
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Running the pipeline](#running-the-pipeline)
    - [With VCF files](#with-vcf-files)
    - [With plink file](#with-plink-file)
    - [With SummaryStats file from GWAs stiudy](#with-summarystats-file-from-gwas-stiudy)
    - [Updating the pipeline](#updating-the-pipeline)
    - [Reproducibility](#reproducibility)
  - [Main arguments](#main-arguments)
    - [`-profile`](#-profile)
  - [Mandatory Params](#mandatory-params)
    - [With VCF files](#with-vcf-files-1)
    - [With plink binary files](#with-plink-binary-files)
    - [With Summary Statistics file](#with-summary-statistics-file)
  - [Optional params](#optional-params)
    - [Annotation Settings](#annotation-settings)
    - [Gene Analysis Settings](#gene-analysis-settings)
    - [Gene Set Analysis Settings](#gene-set-analysis-settings)
    - [Gene Property Analysis](#gene-property-analysis)
    - [Results filtering and Plotting Settings](#results-filtering-and-plotting-settings)
    - [Others params](#others-params)
  - [Output Files](#output-files)
    - [`--reads`](#--reads)
    - [`--single_end`](#--single_end)
  - [Reference genomes](#reference-genomes)
    - [`--genome` (using iGenomes)](#--genome-using-igenomes)
    - [`--fasta`](#--fasta)
    - [`--igenomes_ignore`](#--igenomes_ignore)
  - [Job resources](#job-resources)
    - [Automatic resubmission](#automatic-resubmission)
    - [Custom resource requests](#custom-resource-requests)
  - [AWS Batch specific parameters](#aws-batch-specific-parameters)
    - [`--awsqueue`](#--awsqueue)
    - [`--awsregion`](#--awsregion)
    - [`--awscli`](#--awscli)
  - [Other command line parameters](#other-command-line-parameters)
    - [`--outdir`](#--outdir)
    - [`--email`](#--email)
    - [`--email_on_fail`](#--email_on_fail)
    - [`--max_multiqc_email_size`](#--max_multiqc_email_size)
    - [`-name`](#-name)
    - [`-resume`](#-resume)
    - [`-c`](#-c)
    - [`--custom_config_version`](#--custom_config_version)
    - [`--custom_config_base`](#--custom_config_base)
    - [`--max_memory`](#--max_memory)
    - [`--max_time`](#--max_time)
    - [`--max_cpus`](#--max_cpus)
    - [`--plaintext_email`](#--plaintext_email)
    - [`--monochrome_logs`](#--monochrome_logs)
    - [`--multiqc_config`](#--multiqc_config)

## Introduction

Nextflow handles job submissions on SLURM or other environments, and supervises running the jobs. Thus the Nextflow process must run until the pipeline is finished. We recommend that you put the process running in the background through `screen` / `tmux` or similar tool. Alternatively you can run nextflow within a cluster job submitted your job scheduler.

It is recommended to limit the Nextflow Java virtual machines memory. We recommend adding the following line to your environment (typically in `~/.bashrc` or `~./bash_profile`):

```bash
NXF_OPTS='-Xms1g -Xmx4g'
```

<!-- TODO nf-core: Document required command line parameters to run the pipeline-->

## Running the pipeline

Input can be of two type

- RAW data - VCF files [OR] plink binary files
- GWAS summary stats file

The typical command for running the pipeline is as follows:

### With VCF files

Note: If a VCF csv file is being used as input, then any pre-existing column `SEX` will be ignored and `bcftools plugin vcf2sex` will be used to determine the sex of a VCF file.

```bash
nextflow run main.nf -profile test_with_vcf
```

OR

```bash
nextflow run main.nf \
    --vcf_file testdata/vcfs.csv \
    --gene_loc_file testdata/NCBI37.3/NCBI37.3.gene.loc \
    --set_anot_file testdata/c2.cp.reactome.v7.1.entrez.gmt \
    --outdir results_test_vcf
```

### With plink file

```bash
nextflow run main.nf -profile test_with_plink
```

OR

```bash
nextflow run main.nf \
    --plink_bed testdata/plink_out.bed \
    --plink_bim testdata/plink_out.bim \
    --plink_fam testdata/plink_out.fam \
    --gene_loc_file testdata/NCBI37.3/NCBI37.3.gene.loc \
    --set_anot_file testdata/c2.cp.reactome.v7.1.entrez.gmt \
    --outdir results_test_plink
```

### With Summary Stats file from GWAs study

> Note: Not all the test data comes with source code. It needed to be download individually.

Reference panels can be downloaded from - [MAGMA homepage](https://ctg.cncr.nl/software/magma)

```bash
nextflow run main.nf \
    --summary_stats testdata/saige_results_covid_1.csv \
    --snp_col_name 'SNPID' \
    --pval_col_name 'p.value' \
    --sample_size 151 \
    --ref_panel_bed g1000_eur/g1000_eur.bed \
    --ref_panel_bim g1000_eur/g1000_eur.bim \
    --ref_panel_fam g1000_eur/g1000_eur.fam \
    --ref_panel_synonyms g1000_eur/g1000_eur.synonyms \
    --gene_loc_file testdata/NCBI37.3/NCBI37.3.gene.loc \
    --set_anot_file testdata/c2.cp.reactome.v7.1.entrez.gmt \
    --outdir results_test_sumstat
```

This will launch the pipeline with the `docker` configuration profile. See below for more information about profiles.

Note that the pipeline will create the following files in your working directory:

```bash
work            # Directory containing the nextflow working files
results         # Finished results (configurable, see below)
.nextflow_log   # Log file from Nextflow
# Other nextflow hidden files, eg. history of pipeline runs and old logs.
```

### Updating the pipeline

When you run the above command, Nextflow automatically pulls the pipeline code from GitHub and stores it as a cached version. When running the pipeline after this, it will always use the cached version if available - even if the pipeline has been updated since. To make sure that you're running the latest version of the pipeline, make sure that you regularly update the cached version of the pipeline:

```bash
nextflow pull nf-core/gwasgsa
```

### Reproducibility

It's a good idea to specify a pipeline version when running the pipeline on your data. This ensures that a specific version of the pipeline code and software are used when you run your pipeline. If you keep using the same tag, you'll be running the same version of the pipeline, even if there have been changes to the code since.

First, go to the [nf-core/gwasgsa releases page](https://github.com/nf-core/gwasgsa/releases) and find the latest version number - numeric only (eg. `1.3.1`). Then specify this when running the pipeline with `-r` (one hyphen) - eg. `-r 1.3.1`.

This version number will be logged in reports when you run the pipeline, so that you'll know what you used when you look back in the future.

## Main arguments

### `-profile`

Use this parameter to choose a configuration profile. Profiles can give configuration presets for different compute environments.

Several generic profiles are bundled with the pipeline which instruct the pipeline to use software packaged using different methods (Docker, Singularity, Conda) - see below.

> We highly recommend the use of Docker or Singularity containers for full pipeline reproducibility, however when this is not possible, Conda is also supported.

The pipeline also dynamically loads configurations from [https://github.com/nf-core/configs](https://github.com/nf-core/configs) when it runs, making multiple config profiles for various institutional clusters available at run time. For more information and to see if your system is available in these configs please see the [nf-core/configs documentation](https://github.com/nf-core/configs#documentation).

Note that multiple profiles can be loaded, for example: `-profile test,docker` - the order of arguments is important!
They are loaded in sequence, so later profiles can overwrite earlier profiles.

If `-profile` is not specified, the pipeline will run locally and expect all software to be installed and available on the `PATH`. This is _not_ recommended.

- `docker`
  - A generic configuration profile to be used with [Docker](http://docker.com/)
  - Pulls software from dockerhub: [`nfcore/gwasgsa`](http://hub.docker.com/r/nfcore/gwasgsa/)
- `singularity`
  - A generic configuration profile to be used with [Singularity](http://singularity.lbl.gov/)
  - Pulls software from DockerHub: [`nfcore/gwasgsa`](http://hub.docker.com/r/nfcore/gwasgsa/)
- `conda`
  - Please only use Conda as a last resort i.e. when it's not possible to run the pipeline with Docker or Singularity.
  - A generic configuration profile to be used with [Conda](https://conda.io/docs/)
  - Pulls most software from [Bioconda](https://bioconda.github.io/)
- `test`
  - A profile with a complete configuration for automated testing
  - Includes links to test data so needs no other parameters

<!-- TODO nf-core: Document required command line parameters -->

## Pipeline arguments/Parameters

### Mandatory Params

| param | description |
|-------|-------------|
| `--gene_loc_file` | Gene-SNP mapped Location file (This can be downloaded from MAGMA homepage) |
| `--set_anot_file` | A SET file (Ex. A .gmt file, check MSigDB) |

### Input

Three type input can be given

List of VCFs [OR] PLINK output [OR] Summary Statistics file. Check bellow for details.

#### Input type-1 with VCF files

| param | description |
|-------|-------------|
| `--vcf_file` | A list of VCF in a CSV file (Optional if `--plink_*` OR `--summary_stats` already provided)) |

#### Input type-1 with plink binary files

| param | description |
|-------|-------------|
| `--plink_bim` | Plink .bim file (Optional if `--vcf_file` OR `--summary_stats` already provided) |
| `--plink_bed` | Plink .bed file (Optional if `--vcf_file` OR `--summary_stats` already provided) |
| `--plink_fam` | Plink .fam file (Optional if `--vcf_file` OR `--summary_stats` already provided) |

#### Input type-1 with Summary Statistics file

| param | description |
|-------|-------------|
| `--summary_stats` | A SummaryStats file from GWAS study (Optional if `--vcf_file` or `--plink_*` already provided) |
| `--snp_col_name`| Column name from SummaryStats file in which SNP ids present. (Required only if `--summary_stats` provided ) |
| `--pval_col_name`| Column name from SummaryStats file in which P-values present. (Required only if `--summary_stats` provided ) |
| `--sample_size` | The sample size [N] of the data the SNP p-values (SummaryStats) were obtained (Required only if `--summary_stats` provided ) |
| `--ref_panel_bim` | Reference panel bim file (Required only if `--summary_stats` provided ) |
| `--ref_panel_bed` | Reference panel bed file (Required only if `--summary_stats` provided ) |
| `--ref_panel_fam` | Reference panel fam file (Required only if `--summary_stats` provided ) |
| `--ref_panel_synonyms` | Reference panel synonyms file (Required only if `--summary_stats` provided ) |

## Optional params

### Annotation Settings

| param | description |
|-------|-------------|
| `--window` | Two values (in kilobase) with comma separation. This extends the annotation region by the specified number of kilobases in both directions (Default: 0,0) |
| `--snp_subset` | A .bim file with a subset of SNPs. If provided only these will be filtered during the annotation step and proceed further |

### Gene Analysis Settings

| param | description |
|-------|-------------|
| `--gene_model` | Which model to use during gene p-value calculation [linreg/ snp-wise=mean/snp-wise=top] (Default: snp-wise=mean) Exception: `linger` can't be used with `--summary_stats` |
| `--snp_min_maf` | Minimum SNP minor allele frequency. (Default: 0) |
| `--snp_min_mac` | Minimum SNP minor allele count (Default: 0) |
| `--snp_max_maf` | Maximum SNP minor allele frequency (Default: not applied) |
| `--snp_max_mac` | Maximum SNP minor allele count (Default: not applied) |
| `--snp_max_miss` | Maximum allowed SNP missingness (Default: 0.05) |
| `--snp_diff` | SNP differential missingness test threshold (Default: 1e-6) |
| `--seed` | Use to set the seed of the random number generator in some gene analysis models (Default: not applied) |
| `--burden` | Specifying burden score settings for rare variants Exception: can't be used with `--summary_stats`|
| `--big_data` | Special mode for reducing running time and memory usage when analyzing very large data sets |

### Gene Set Analysis Settings

| param | description |
|-------|-------------|
| `--gene_info` | per-gene information [true/false] (Default: false) |
| `--outlier_up`, `--outlier_down` | Z-core cutoff for detecting outlier (Default: lower-3 upper-6) |
| `--direction_sets` | The direction of testing in the model (Default: 'positive') accepted values for all directions ‘pos’/‘positive’/‘greater’, ‘neg’/‘negative’/‘smaller’ and ‘both’/‘two’/‘twosided’/‘two-sided’ |
| `--self_contained` | perform an additional self-contained gene-set analysis for all gene sets [true/false] (Default: false) |
| `--alpha` | sets the significance level. Takes numeric value (Default: Not applied) |
| `--correct` | Control the automatic correction for technical data-level properties [all/none] (Default: all) |

### Gene Property Analysis

| param | description |
|-------|-------------|
| `--cov_file` | Provide a covariate file Exception: can't be used with `--summary_stats` |

### Results filtering and Plotting Settings

| param | description |
|-------|-------------|
| `--pvalue_cutoff` | P value to be applied on GeneSet while plotting. (Default: 0.05) |
| `--top_n_value` | Number of top significant to keep from GeneSet while plotting. (Default: 10) |

### Others params

| param | description |
|-------|-------------|
| `--outdir` | Output directory name (Default: Results in current directory) |
| `--help` | Show help menu |
| `-resume` | Nextflow param, help in resume a run |

## Output Files

| file name | description |
|-------|-------------|
| **magma_out.genes.annot** | This file contains the SNP to gene annotation mapping information. |
| **magma_out.genes.annot.log** | Log from the annotation run step. |
| **magma_out.genes.out** | (Human Readable) Individual genes calculated p-value from gene analysis step. |
| **magma_out.genes.raw** | (Machine Readable) Individual genes calculated p-value from gene analysis step. |
| **magma_out.genes.out.log** | Log from the gene analysis step. |
| **magma_out.gsa.out** | Final Result of Gene-Set-Analysis. Contains information about Gene-Set and their corresponding p-value. |
| **magma_out.gsa.out.log** | Log from the Gene-Set-Analysis step. |
| **magma_out.gsa.out.sorted.csv** | Same information as **magma_out.gsa.out**, but sorted based on p-value and in comma separated format. |
| **magma_out.gsa.out.sorted.genename.tsv** | With additional column of Gene Names |
| **magma_out.gsa.out.top_10.plot.csv** | Top N number of Gene-Set after sorted based on p-value. This can be treated as significant Gene-Sets from the analysis. |
| **magma_out.gsa.out.top_10.plot.genename.tsv**| With additional column of Gene Names |
| **magma_out.gsa.out.top_10.plot.plot** | A dotdot representing significant Gene-Sets. |

<!-- TODO nf-core: clean bellow -->

## Job resources

### Automatic resubmission

Each step in the pipeline has a default set of requirements for number of CPUs, memory and time. For most of the steps in the pipeline, if the job exits with an error code of `143` (exceeded requested resources) it will automatically resubmit with higher requests (2 x original, then 3 x original). If it still fails after three times then the pipeline is stopped.

### Custom resource requests

Wherever process-specific requirements are set in the pipeline, the default value can be changed by creating a custom config file. See the files hosted at [`nf-core/configs`](https://github.com/nf-core/configs/tree/master/conf) for examples.

If you are likely to be running `nf-core` pipelines regularly it may be a good idea to request that your custom config file is uploaded to the `nf-core/configs` git repository. Before you do this please can you test that the config file works with your pipeline of choice using the `-c` parameter (see definition below). You can then create a pull request to the `nf-core/configs` repository with the addition of your config file, associated documentation file (see examples in [`nf-core/configs/docs`](https://github.com/nf-core/configs/tree/master/docs)), and amending [`nfcore_custom.config`](https://github.com/nf-core/configs/blob/master/nfcore_custom.config) to include your custom profile.

If you have any questions or issues please send us a message on [Slack](https://nf-co.re/join/slack).

## AWS Batch specific parameters

Running the pipeline on AWS Batch requires a couple of specific parameters to be set according to your AWS Batch configuration. Please use [`-profile awsbatch`](https://github.com/nf-core/configs/blob/master/conf/awsbatch.config) and then specify all of the following parameters.

### `--awsqueue`

The JobQueue that you intend to use on AWS Batch.

### `--awsregion`

The AWS region in which to run your job. Default is set to `eu-west-1` but can be adjusted to your needs.

### `--awscli`

The [AWS CLI](https://www.nextflow.io/docs/latest/awscloud.html#aws-cli-installation) path in your custom AMI. Default: `/home/ec2-user/miniconda/bin/aws`.

Please make sure to also set the `-w/--work-dir` and `--outdir` parameters to a S3 storage bucket of your choice - you'll get an error message notifying you if you didn't.

## Other command line parameters

<!-- TODO nf-core: Describe any other command line flags here -->

### `--outdir`

The output directory where the results will be saved.

### `--email`

Set this parameter to your e-mail address to get a summary e-mail with details of the run sent to you when the workflow exits. If set in your user config file (`~/.nextflow/config`) then you don't need to specify this on the command line for every run.

### `--email_on_fail`

This works exactly as with `--email`, except emails are only sent if the workflow is not successful.

### `--max_multiqc_email_size`

Threshold size for MultiQC report to be attached in notification email. If file generated by pipeline exceeds the threshold, it will not be attached (Default: 25MB).

### `-name`

Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.

This is used in the MultiQC report (if not default) and in the summary HTML / e-mail (always).

**NB:** Single hyphen (core Nextflow option)

### `-resume`

Specify this when restarting a pipeline. Nextflow will used cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously.

You can also supply a run name to resume a specific run: `-resume [run-name]`. Use the `nextflow log` command to show previous run names.

**NB:** Single hyphen (core Nextflow option)

### `-c`

Specify the path to a specific config file (this is a core NextFlow command).

**NB:** Single hyphen (core Nextflow option)

Note - you can use this to override pipeline defaults.

### `--custom_config_version`

Provide git commit id for custom Institutional configs hosted at `nf-core/configs`. This was implemented for reproducibility purposes. Default: `master`.

```bash
## Download and use config file with following git commid id
--custom_config_version d52db660777c4bf36546ddb188ec530c3ada1b96
```

### `--custom_config_base`

If you're running offline, nextflow will not be able to fetch the institutional config files
from the internet. If you don't need them, then this is not a problem. If you do need them,
you should download the files from the repo and tell nextflow where to find them with the
`custom_config_base` option. For example:

```bash
## Download and unzip the config files
cd /path/to/my/configs
wget https://github.com/nf-core/configs/archive/master.zip
unzip master.zip

## Run the pipeline
cd /path/to/my/data
nextflow run /path/to/pipeline/ --custom_config_base /path/to/my/configs/configs-master/
```

> Note that the nf-core/tools helper package has a `download` command to download all required pipeline
> files + singularity containers + institutional configs in one go for you, to make this process easier.

### `--max_memory`

Use to set a top-limit for the default memory requirement for each process.
Should be a string in the format integer-unit. eg. `--max_memory '8.GB'`

### `--max_time`

Use to set a top-limit for the default time requirement for each process.
Should be a string in the format integer-unit. eg. `--max_time '2.h'`

### `--max_cpus`

Use to set a top-limit for the default CPU requirement for each process.
Should be a string in the format integer-unit. eg. `--max_cpus 1`

### `--plaintext_email`

Set to receive plain-text e-mails instead of HTML formatted.

### `--monochrome_logs`

Set to disable colourful command line output and live life in monochrome.

### `--multiqc_config`

Specify a path to a custom MultiQC configuration file.
