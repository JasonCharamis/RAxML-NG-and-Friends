**Scalable RAxML-NG-based phylogenetic analysis using Snakemake**

This is a Snakemake pipeline for scalable maximum likelihood (ML) phylogenetic analysis using RAxML-NG and the associated tools. This pipeline is considerbly slower than the IQ-TREE-based one, but is much more comprehensive and performs much better in terms of accuracy, especially in difficult-to-analyze datasets.

This workflow performs all needed steps sequentially, from MSA to model selection and phylogeny inference.

Wildcard is {identifier}.fasta

Usage:

snakemake --cores 10 --snakefile Snakefile

Dependencies:

Mafft
https://github.com/GSLBiotech/mafft

Trimal
https://github.com/inab/trimal

Pythia
https://github.com/tschuelia/PyPythia

ModelTest-NG
https://github.com/ddarriba/modeltest

RAxML-NG
https://github.com/amkozlov/raxml-ng

ETE3
http://etetoolkit.org/
