# t1k

## Overview
T1K (The ONE genotyper for Kir and HLA) is a computational tool to infer the alleles for the polymorphic genes such as KIR and HLA. T1K calculates the allele abundances based on the RNA-seq/WES/WGS read alignments on the provided allele reference sequences. The abundances are used to pick the true alleles for each gene. T1K provides the post analysis steps, including novel SNP detection and single-cell representation. T1K supports both single-end and paired-end sequencing data with any read length.

## Dependencies

* [t1k 1.0.2](https://github.com/mourisl/T1K)


## Usage

### Cromwell
```
java -jar cromwell.jar run t1k.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputBam`|File|Input alignment file
`libraryDesign`|String|Library type: 'EX', 'WG', or 'WT'
`outputFileNamePrefix`|String|Output prefix, customizable. Default is the first file's basename.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`hlaTyping.modules`|String|"t1k/1.0.2"|Names and versions of required modules
`hlaTyping.jobMemory`|Int|16|Memory allocated to the task
`hlaTyping.timeout`|Int|96|Timeout in hours, needed to override imposed limits
`kirTyping.modules`|String|"t1k/1.0.2"|Names and versions of required modules
`kirTyping.jobMemory`|Int|16|Memory allocated to the task
`kirTyping.timeout`|Int|96|Timeout in hours, needed to override imposed limits


### Outputs

Output | Type | Description | Labels
---|---|---|---
`hlaResults`|File|File with HLA typing results|vidarr_label: hlaResults
`kirResults`|File?|File with KIR typing results|vidarr_label: kirResults


## Commands
This section lists command(s) run by the t1k workflow
 
* Running t1k
 
### HLA Typing 
 
```
     set -euo pipefail
 
     $T1K_ROOT/run-t1k \
     -b INPUT_BAM \
     --preset PRESET \
     -f REFERENCE_SEQUENCE_FASTA \
     -c REFERENCE_COORDINATE_FASTA \
     -o OUTPUT_HLA_CALLS
```

### KIR Typing
```
     set -euo pipefail
 
     $T1K_ROOT/run-t1k \
     -b INPUT_BAM \
     --preset PRESET \
     -f REFERENCE_SEQUENCE_FASTA \
     -c REFERENCE_COORDINATE_FASTA \
     -o OUTPUT_KIR_CALLS
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
