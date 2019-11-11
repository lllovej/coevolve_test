#!/bin/bash -l
#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
#SBATCH -t 00:30:00
#SBATCH --array=1-10
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/dev_file/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/dev_file/%A_%a.out

#load modules
module load Anaconda3/4.4.0

#get the argument from the input
if [ -z $1 ]
then 
	offset=0
else
	offset=$1
fi
mkdir aa_$(($1+10))/
proteome_list=/home/j/juliezhu/pfs/data/full_name_cut
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
f_name=$(sed -n ${idx}p $proteome_list)
#f_name=$(sed -n ${SLURM_ARRAY_TASK_ID}p $proteome_list)

$echo $idx
#echo $f_name

#j='j'
#download the data
url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/
wget $url$f_name -o aa_$(($1+10))/${f_name}
#another way: 
#wget $url$f_name -o ./0001_1000/${f_name}
rm *.gz
wait 
