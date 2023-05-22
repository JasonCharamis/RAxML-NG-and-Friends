Scalable phylogenetic analysis using Snakemake

This is a Snakemake pipeline for scalable maximum likelihood (ML) phylogenetic analysis using RAxML-NG and the associated tools. This pipeline is slower than IQ-TREE-based phylogenies, but is much more comprehensive and performs much better in terms of accuracy, especially in difficult-to-analyze datasets.

It includes producing and editing the multiple sequence alignment (MSA), and using the modified MSA for maximum likelihood phylogenetic analysis.

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
