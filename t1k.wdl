version 1.0

struct t1kResources {
  String hlaPreset
  String hlaReferenceSequence
  String kirReferenceSequence
}

workflow t1k {
  input {
    File fastqR1 
    File fastqR2
    String libraryDesign
    String outputFileNamePrefix
  }

  parameter_meta {
    fastqR1: "Input file with the first mate reads."
    fastqR2: " Input file with the second mate reads."
    libraryDesign: "Library type, either 'WG' or 'WT'"
    outputFileNamePrefix: "Output prefix, customizable. Default is the first file's basename."
  }

  Map[String,t1kResources] resources = {
    "WG": {
      "hlaPreset": "hla-wgs",
      "hlaReferenceSequence": "$T1K_ROOT/hla_dna_seq.fa",
      "kirReferenceSequence": "$T1K_ROOT/kir_dna_seq.fa"
    },
    "WT": {
      "hlaPreset": "hla",
      "hlaReferenceSequence": "$T1K_ROOT/hla_rna_seq.fa",
      "kirReferenceSequence": "$T1K_ROOT/kir_rna_seq.fa"
    }
  }


  call hlaTyping {
    input:
      inputFastq1 = fastqR1,
      inputFastq2 = fastqR2,
      preset = resources[libraryDesign].hlaPreset,
      referenceSequence = resources[libraryDesign].hlaReferenceSequence,
      outputFileNamePrefix = outputFileNamePrefix
  }

  if(libraryDesign=="WG") {
    call kirTyping {
      input:
        inputFastq1 = fastqR1,
        inputFastq2 = fastqR2,
        referenceSequence = resources[libraryDesign].kirReferenceSequence,
        outputFileNamePrefix = outputFileNamePrefix
    }
  }

  meta {
    author: "Hannah Driver"
    email: "hdriver@oicr.on.ca"
    description: "T1K (The ONE genotyper for Kir and HLA) is a computational tool to infer the alleles for the polymorphic genes such as KIR and HLA."
    dependencies: [
      {
        name: "t1k/1.0.2",
        url: "https://github.com/mourisl/T1K"
      }
    ]
    output_meta: {
      hlaResults: "File with HLA typing results",
      kirResults: "File with KIR typing results"
    }
  }

  output {
    File hlaResults = hlaTyping.hlaResults
    File? kirResults = kirTyping.kirResults
  }

}


task hlaTyping {
  input {
    File inputFastq1
    File inputFastq2
    String preset
    String referenceSequence
    String outputFileNamePrefix
    String modules = "t1k/1.0.2"
    Int jobMemory = 16
    Int timeout = 96
  }

  command <<<
    set -euo pipefail

    $T1K_ROOT/run-t1k \
    -1 ~{inputFastq1} \
    -2 ~{inputFastq2} \
    --preset ~{preset} \
    -f ~{referenceSequence} \
    -o ~{outputFileNamePrefix}"_t1k_hla"
  >>>

  parameter_meta {
    inputFastq1: "Input fastq with first mate reads"
    inputFastq2: "Input fastq with second mate reads"
    preset: "Predefined setting that specifies which analysis to execute"
    referenceSequence: "Path to the reference fasta file"
    outputFileNamePrefix: "Output prefix for the result file" 
    modules: "Names and versions of required modules"
    jobMemory: "Memory allocated to the task"
    timeout: "Timeout in hours, needed to override imposed limits"
  }

  runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File hlaResults = "~{outputFileNamePrefix}_t1k_hla_genotype.tsv"
  }
}


task kirTyping {
  input {
    File inputFastq1
    File inputFastq2
    String referenceSequence
    String outputFileNamePrefix
    String modules = "t1k/1.0.2"
    Int jobMemory = 16
    Int timeout = 96
  }

  command <<<
    set -euo pipefail

    $T1K_ROOT/run-t1k \
    -1 ~{inputFastq1} \
    -2 ~{inputFastq2} \
    --preset kir-wgs \
    -f ~{referenceSequence} \
    -o ~{outputFileNamePrefix}"_t1k_kir"
  >>>

  parameter_meta {
    inputFastq1: "Input fastq with first mate reads"
    inputFastq2: "Input fastq with second mate reads"
    referenceSequence: "Path to the reference fasta file"
    outputFileNamePrefix: "Output prefix for the result file"
    modules: "Names and versions of required modules"
    jobMemory: "Memory allocated to the task"
    timeout: "Timeout in hours, needed to override imposed limits"
  }

  runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File kirResults = "~{outputFileNamePrefix}_t1k_kir_genotype.tsv"
  }
}
