#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
ecoli_file=/home/j/juliezhu/pfs/data/ref_proteomes/ecoli_data/after_rem.fasta
proteome_list=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/proteome_list
pname=$(sed -n ${idx}p $proteome_list)

psiblast -query $ecoli_file -db ../alldata_db/$pname -out ../blast_out/$pname -num_iterations 3 -evalue 0.01 -outfmt "6 qseqid sseqid qlen slen length qcovs pident qstart qend sstart send evalue"

