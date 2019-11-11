#!/bin/bash 
#SBATCH -A SNIC2019-3-319
#SBATCH -c 2
#SBATCH -t 12:00:00
#SBATCH --array=1-10
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/out/%A_%a.out

ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

file=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/createdb_name
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
f_name=$(sed -n ${idx}p $file)
pref=$(echo $f_name | cut -d '.' -f 1)
f_name="$pref.m8"

cd ../result/
#run python parsing the data
python ../bin/parsing_mmseqsrbh.py $f_name

wait
