version 1.0

struct t1kResources {
  String hlaPreset
  String hlaReferenceSequence
  String hlaReferenceCoord
  String kirPreset
  String kirReferenceSequence
  String kirReferenceCoord
}

workflow t1k {
  input {
    File inputBam
    String libraryDesign
    String outputFileNamePrefix
  }

  parameter_meta {
    inputBam: "Input alignment file"
    libraryDesign: "Library type: 'EX', 'WG', or 'WT'"
    outputFileNamePrefix: "Output prefix, customizable. Default is the first file's basename."
  }

  Map[String,t1kResources] resources = {
    "EX": {
      "hlaPreset": "hla",
      "hlaReferenceSequence": "$T1K_ROOT/hla_dna_seq.fa",
      "hlaReferenceCoord": "$T1K_ROOT/hla_dna_coord.fa",
      "kirPreset": "kir-wes",
      "kirReferenceSequence": "$T1K_ROOT/kir_dna_seq.fa",
      "kirReferenceCoord": "$T1K_ROOT/kir_dna_coord.fa"
    },
    "WG": {
      "hlaPreset": "hla-wgs",
      "hlaReferenceSequence": "$T1K_ROOT/hla_dna_seq.fa",
      "hlaReferenceCoord": "$T1K_ROOT/hla_dna_coord.fa",
      "kirPreset": "kir-wgs",
      "kirReferenceSequence": "$T1K_ROOT/kir_dna_seq.fa",
      "kirReferenceCoord": "$T1K_ROOT/kir_dna_coord.fa"
    },
    "WT": {
      "hlaPreset": "hla",
      "hlaReferenceSequence": "$T1K_ROOT/hla_rna_seq.fa",
      "hlaReferenceCoord": "$T1K_ROOT/hla_rna_coord.fa",
      "kirPreset": "",
      "kirReferenceSequence": "$T1K_ROOT/kir_rna_seq.fa",
      "kirReferenceCoord": "$T1K_ROOT/kir_rna_coord.fa"
    }
  }


  call hlaTyping {
    input:
      inputBam = inputBam,
      preset = resources[libraryDesign].hlaPreset,
      referenceSequence = resources[libraryDesign].hlaReferenceSequence,
      referenceCoord = resources[libraryDesign].hlaReferenceCoord,
      outputFileNamePrefix = outputFileNamePrefix
  }

  if(libraryDesign!="WT") {
    call kirTyping {
      input:
        inputBam = inputBam,
        preset = resources[libraryDesign].kirPreset,
        referenceSequence = resources[libraryDesign].kirReferenceSequence,
        referenceCoord = resources[libraryDesign].kirReferenceCoord,
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
    File inputBam
    String preset
    String referenceSequence
    String referenceCoord
    String outputFileNamePrefix
    String modules = "t1k/1.0.2"
    Int jobMemory = 16
    Int timeout = 96
  }

  command <<<
    set -euo pipefail

    $T1K_ROOT/run-t1k \
    -b ~{inputBam} \
    --preset ~{preset} \
    -f ~{referenceSequence} \
    -c ~{referenceCoord} \
    -o ~{outputFileNamePrefix}"_t1k_hla"
  >>>

  parameter_meta {
    inputBam: "Input alignment file"
    preset: "Predefined setting that specifies which analysis to execute"
    referenceSequence: "Path to the reference sequence fasta file"
    referenceCoord: "Path to the reference coordinates fasta file"
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
    File inputBam
    String preset
    String referenceSequence
    String referenceCoord
    String outputFileNamePrefix
    String modules = "t1k/1.0.2"
    Int jobMemory = 16
    Int timeout = 96
  }

  command <<<
    set -euo pipefail

    $T1K_ROOT/run-t1k \
    -b ~{inputBam} \
    --preset ~{preset} \
    -f ~{referenceSequence} \
    -c ~{referenceCoord} \
    -o ~{outputFileNamePrefix}"_t1k_kir"
  >>>

  parameter_meta {
    inputBam: "Input alignment file"
    preset: "Predefined setting that specifies which analysis to execute"
    referenceSequence: "Path to the reference sequence fasta file"
    referenceCoord: "Path to the reference coordinates fasta file"
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
