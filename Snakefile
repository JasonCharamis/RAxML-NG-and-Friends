midpoint_option = snakemake.params.get('midpoint', True)

seq = { f[:-6] for f in os.listdir(".") if f.endswith(".fasta") }

rule all:
     input:
        "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted",
	"all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted.svg"

rule concatenate:
     input: expand ("{seq}.fasta", seq=seq)
     output: all_fasta="all_genes.fasta"
     shell: "cat *.fasta > {output.all_fasta}"
     	    
rule mafft:
     input: all_fasta="all_genes.fasta"
     output: aln="all_genes.aln"
     shell: "mafft --auto {input.all_fasta} > {output.aln}"

rule trimal:
     input: aln="all_genes.aln"
     output: trm="all_genes.aln.trimmed"
     params:
	thr=config['trimal_threshold']
     shell: "trimal -in {input.aln} -out {output.trm} -fasta -gt {params.thr}"

rule convert:
     input: trm="all_genes.aln.trimmed"
     output: phy="all_genes.aln.trimmed.phy"
     message: "Converting trimmed alignment to phy"
     shell: "/home/iasonas/bin/convert.sh {input.trm} > {output.phy}"

rule pythia:
     input: phy="all_genes.aln.trimmed.phy"
     output: "all_genes.aln.pythia.out"
     shell: "pythia --msa {input.phy} -r /home/iasonas/Programs/raxml-ng/bin/raxml-ng-mpi --removeDuplicates -o {output}"

rule model_test:
     input:
	phy="all_genes.aln.trimmed.phy",
	pythia="all_genes.aln.pythia.out"
     output: "all_genes.trimmed.aln.phy.out"
     shell: "modeltest-ng -i {input.phy} -d aa -t ml -c -T raxml"
     
rule raxml:
     input: pythia="all_genes.aln.pythia.out",
     	    modeltest="all_genes.trimmed.aln.phy.out"
     output: "all_genes.trimmed.aln.phy.raxml.support"
     threads: config['raxmlng_threads']
     params:
	rtn: config['random_tree_number']
	ptn: config['parsimony_tree_number']
	outgroup: config['outgroup']
	midpoint_option=midpoint_option
     shell:
	""" 
	if [ "{params.midpoint_option}" == "True" ]; then
	     /home/iasonas/Programs/raxml-ng/bin/raxml-ng-mpi --all --msa all_genes.aln.trimmed.phy --model LG+G4 --tree rand{{{params.rtn}}},pars{{{params.ptn}}} --threads {params.raxmlng_threads} --workers auto 
	else
	     /home/iasonas/Programs/raxml-ng/bin/raxml-ng-mpi --all --msa all_genes.aln.trimmed.phy --model LG+G4 --tree rand{{{params.rtn}}},pars{{{params.ptn}}} --outgroup {params.outgroup} --threads {raxmlng_
threads} --workers auto
	
	fi
	"""

rule midpoint_root:
     input: "all_genes.trimmed.aln.phy.raxml.support"
     output: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted"
     params:
        midpoint_option=midpoint_option
    shell:
        """
        if [ "{params.midpoint_option}" == "True" ]; then
            python3 /home/iasonas/bin/ETElib.py --tree {input} --midpoint
        else
            ln -s {input} {output}  # create a symbolic link if midpoint is False
        fi
        """

rule visualize_tree:
     input: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted"
     output: "all_genes.trimmed.aln.phy.raxml.support.midpoint_rooted.svg"
     shell: "conda activate ete && python3 /home/iasonas/bin/ETElib.py --visualize --tree {input}"
