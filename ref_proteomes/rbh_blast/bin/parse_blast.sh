#!/bin/bash 
#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
###SBATCH -p largemem
#SBATCH -t 00:15:00
#SBATCH --array=1-1000
#SBATCH --error=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/out/%A_%a.out

ml GCC/8.2.0-2.31.1  OpenMPI/3.1.3 ADIOS2/2.5.0-Python-3.7.2

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

file=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqs/createdb_name
#idx=1
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
f_name=$(sed -n ${idx}p $file)
pref=$(echo $f_name | cut -d '.' -f 1)

cd ../recipro_hit/
#run python parsing the data
python ../bin/parsing_blast.py $pref

wait
