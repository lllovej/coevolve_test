#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/out/%A_%a.out

#insert modules
ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
proteome_list=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/proteome_list
pname=$(sed -n ${idx}p $proteome_list)

cd ../blast_out/

##1step: remove blank lines and lines with "Search has converged!" OBS: i use '-i' means change inplace which I could only run once.
#sed -i '/^Search.*/d;/^$/d' $pname

#run the forward filter 
python ../bin/blast_mainfilter.py $pname forward 
