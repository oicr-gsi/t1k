# t1k

T1K (The ONE genotyper for Kir and HLA) is a computational tool to infer the alleles for the polymorphic genes such as KIR and HLA.

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
`inputBam`|File|Input alignment file
`libraryDesign`|String|Library type, either 'WG' or 'WT'
`outputFileNamePrefix`|String|Output prefix, customizable. Default is the first file's basename.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


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
 ```
     set -euo pipefail
 
     $T1K_ROOT/run-t1k \
     -b INPUT_BAM \
     --preset kir-wgs \
     -f REFERENCE_SEQUENCE_FASTA \
     -c REFERENCE_COORDINATE_FASTA \
     -o OUTPUT_KIR_CALLS
   ```

 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
