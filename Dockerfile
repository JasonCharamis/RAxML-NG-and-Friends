## Dockerfile to build Docker image for this Snakemake workflow.

FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="1dffc5147149cba73e037f03ff8793aa49d669d6249b3ec0b1d3f135fa60c7bd"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: envs/phylo.yaml
#   prefix: /conda-envs/e7731bb49f40c7aec2d59fb33378cd57
#   name: phylo
#   channels:
#       - conda-forge
#       - bioconda
#   dependencies:
#       - mafft
#       - trimal
#       - pypythia
#       - modeltest-ng
#       - raxml-ng
RUN mkdir -p /conda-envs/e7731bb49f40c7aec2d59fb33378cd57
COPY envs/phylo.yaml /conda-envs/e7731bb49f40c7aec2d59fb33378cd57/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/e7731bb49f40c7aec2d59fb33378cd57 --file /conda-envs/e7731bb49f40c7aec2d59fb33378cd57/environment.yaml && \
    mamba clean --all -y
