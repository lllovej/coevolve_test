#!/bin/bash 
#SBATCH -A SNIC2019-3-319
#SBATCH -c 2
#SBATCH -t 00:20:00
#SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

proteome_list=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqs/createdb_name
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
f_name=$(sed -n ${idx}p $proteome_list)
db_name=$(echo $f_name| cut -d '.' -f 1)


cd ../forward/
#run mmseqs
mmseqs search ../../ecoli_data/ecoliDB ../../rbh_mmseqs/alldata_db/$db_name $db_name tmp/$db_name --num-iterations 4 --remove-tmp-files
mmseqs convertalis ../../ecoli_data/ecoliDB ../../rbh_mmseqs/alldata_db/$db_name $db_name ${db_name}_fw.m8 --format-output "query,target,pident,alnlen,qstart,qend,tstart,tend,qcov,tcov,evalue"

