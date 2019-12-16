#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 20:00:00
#SBATCH --array=1-1000 
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/out/%A_%a.out

#get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

proteome_list=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/createdb_name
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
f_name=$(sed -n ${idx}p $proteome_list)
db_name=$(echo $f_name| cut -d '.' -f 1)

cd alldata_db/
#create blast database
makeblastdb -in ../../all_data/unzipped/$f_name -dbtype prot -out $db_name -parse_seqids

#create one blast database for all proteomes
#makeblastdb -in ../../all_data/whole.fasta -dbtype prot -out ../refproteomeDB -parse_seqids
