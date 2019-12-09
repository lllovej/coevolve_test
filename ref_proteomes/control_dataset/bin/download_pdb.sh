#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --array=1-245
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

#idx=16
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
file=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/ecolippi_petras
line=$(sed -n ${idx}p $file)

#get the filename
string=$(echo $line| cut -d '|' -f3|cut -d ',' -f1)
filename=$(echo $string| cut -d '_' -f1)
middle_name=${filename:1:2}
#chain=$(echo $string|cut -d '_' -f2)
#middlepoint=$(expr ${#chain} / 2)
#chainA=$(echo -n $chain | head -c $middlepoint)
#chainB=$(echo -n $chain | tail -c $middlepoint)
cd ../pdb_petras/
wget ftp://ftp.wwpdb.org/pub/pdb/data/structures/divided/pdb/$middle_name/"pdb$filename".ent.gz
