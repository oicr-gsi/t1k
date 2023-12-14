#!/bin/bash
cd $1

# We have two main output files, .tsv files with allele predictions

find . -name "*hla_genotype.tsv" | xargs md5sum
find . -name "*kir_genotype.tsv" | xargs md5sum
