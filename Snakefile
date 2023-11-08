configfile: "config.yaml"

seq = { f[:-6] for f in os.listdir(".") if f.endswith(".fasta") }

rule all:
     input:
        "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted",
	"all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted.svg"

rule concatenate:
     input: expand ("{seq}.fasta", seq=seq)
     output: "all_genes.fasta"
     shell: "cat *.fasta > {output}"
     	    
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
     shell: "/home/iasonas/bin/convert.sh {input} > {output}"

rule pythia:
     input: "all_genes.aln.trimmed.phy"
     output: "all_genes.aln.pythia.out"
     shell: "pythia --msa {input} -r /home/iasonas/Programs/raxml-ng/bin/raxml-ng-mpi --removeDuplicates -o {output}"

rule modeltest:
     input: "all_genes.aln.trimmed.phy","all_genes.aln.pythia.out"
     output: "all_genes.trimmed.aln.phy.out"
     shell: "modeltest-ng -i {input[0]} -d aa -t ml -c -T raxml"

rule raxml:
     input: "all_genes.aln.pythia.out"
     output: "all_genes.trimmed.aln.phy.raxml.support"
     threads: config['threads']
     params: rtn=config['random_tree_number'], ptn=config['parsimony_tree_number']
     shell: """ /home/iasonas/Programs/raxml-ng/bin/raxml-ng-mpi --all --msa all_genes.aln.trimmed.phy --model LG+G4 --tree rand{{{params.rtn}}},pars{{{params.ptn}}} --threads {threads} --workers auto """

rule midpoint_root:
     input: "all_genes.trimmed.aln.phy.raxml.support"
     output: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted"
     shell: "python /home/iasonas/bin/midpoint.py {input[0]}"

rule visualize_tree:
     input: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted"
     output: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted.svg"
     shell: "conda activate ete && python3 /home/iasonas/bin/ETElib.py --visualize --tree {input}"
