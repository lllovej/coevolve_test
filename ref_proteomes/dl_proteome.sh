#!/bin/bash -l
#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
#SBATCH -t 20:00:00
#SBATCH --array=1-50
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/dev_file/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/dev_file/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then 
	offset=0
else
	offset=$1
fi

proteome_list=/home/j/juliezhu/pfs/data/ref_proteome_all
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
f_name=$(sed -n ${idx}p $proteome_list)

#download the data
url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/
##download using wget
wget $url$f_name

##for remaining
#wget $url$f_name -o 'aa_6566/'${f_name}
##another way: 
#wget $url$f_name -o ./0001_1000/${f_name}
wait 
