#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --array=1-66
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

idx=1
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
file=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/ecolippi_83333
line=$(sed -n ${idx}p $file)
pr1=$(echo $line| cut -d '|' -f1)
pr2=$(echo $line| cut -d '|' -f2)

ortholog_path=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/ortholog
col1=$(cut -d '	' -f2 $ortholog_path/$pr1.fa)
echo $col1

