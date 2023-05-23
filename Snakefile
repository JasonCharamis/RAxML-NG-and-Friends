seq = { f[:-6] for f in os.listdir(".") if f.endswith(".fasta") }

rule all:
     input: "all_genes.aln",
            "all_genes.aln.trimmed",
            "all_genes.aln.trimmed.phy",
            "all_genes.aln.pythia.out",
            "all_genes.trimmed.aln.phy.raxml.support",
            "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted"

rule concatenate:
     input: expand ("{seq}.fasta", seq=seq)
     output: "all_genes.fasta"
     shell: "cat {input[0]} > {output[0]}"
            
rule mafft:
     input: "all_genes.fasta"
     output: "all_genes.aln"
     shell: "mafft --auto {input[0]} > {output[0]}"

rule trimal:
     input: "all_genes.aln"
     output: "all_genes.aln.trimmed"
     shell: "trimal -in {input} -out {output} -fasta -gt 0.50"

rule convert:
     input: "all_genes.aln.trimmed"
     output:"all_genes.aln.trimmed.phy"
     shell: "./aln2phylip.sh {input} > {output}"

rule pythia:
     input: "all_genes.aln.trimmed.phy"
     output: "all_genes.aln.pythia.out"
     shell: "pythia --msa {input} -r /home/iasonas/Programs/raxml-ng/bin/raxml-ng --removeDuplicates -o {output}"

rule modeltest:
     input: "all_genes.aln.trimmed.phy","all_genes.aln.pythia.out"
     output: "all_genes.trimmed.aln.phy.out"
     shell: "modeltest-ng -i {input[0]} -d aa -t ml -c -T raxml"

rule raxml:
     input: msa="all_genes.aln.trimmed.phy",
            pythia="all_genes.aln.pythia.out",
            modeltest="all_genes.trimmed.aln.phy.out"
     output: "all_genes.trimmed.aln.phy.raxml.bestTreeCollapsed","all_genes.trimmed.aln.phy.raxml.support"
     shell: "MODEL=`grep -P "\sBIC" all_genes.pep.aln.trimmed.phy.log | grep -v "Best" | sed 's/.*               //g' | sed 's/ .*//g'` && 
            raxml-ng-mpi --all --msa {input.msa} --model $MODEL --tree rand{10},pars{90} --threads 40"

rule midpoint_root:
     input: "all_genes.trimmed.aln.phy.raxml.bestTreeCollapsed","all_genes.trimmed.aln.phy.raxml.support"
     output: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted"
     shell: "python3 midpoint.py {input[0]}"
