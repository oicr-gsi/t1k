# t1k



## Overview

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
`fastqR1`|File|Input file with the first mate reads.
`fastqR2`|File| Input file with the second mate reads.
`libraryDesign`|String|Library type, either 'WG' or 'WT'
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

Output | Type | Description
---|---|---
`hlaResults`|File|File with HLA typing results
`kirResults`|File?|File with KIR typing results


## Commands
 This section lists command(s) run by the t1k workflow
 
 * Running t1k
 
 === HLA Typing ===.
 
 <<<
     set -euo pipefail
 
     $T1K_ROOT/run-t1k \
     -1 INPUT_FASTQ_R1 \
     -2 INPUT_FASTQ_R2 \
     --preset PRESET \
     -f REFERENCE_FASTA \
     -o OUTPUT_FILE_NAME
   >>>
 
 
 === KIR Typing ===.
 <<<
     set -euo pipefail
 
     $T1K_ROOT/run-t1k \
     -1 INPUT_FASTQ_R1 \
     -2 INPUT_FASTQ_R2 \
     --preset kir-wgs \
     -f REFERENCE_FASTA \
     -o OUTPUT_FILE_NAME
   >>>
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
