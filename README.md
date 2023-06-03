**Scalable RAxML-NG-based phylogenetic analysis using Snakemake**

This is a Snakemake workflow for running scalable maximum likelihood (ML) phylogenetic analysis using RAxML-NG and associated tools (Pythia, ModelTest-NG). This workflow is considerably slower than the IQ-TREE-based one, but is much better in terms of accuracy, especially in difficult-to-analyze datasets.

This workflow performs all steps sequentially, from MSA to model selection and phylogeny inference.


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
