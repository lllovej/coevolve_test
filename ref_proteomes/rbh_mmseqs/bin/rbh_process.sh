#!/bin/bash 
#SBATCH -A SNIC2019-3-319
#SBATCH -c 28
#SBATCH -t 24:00:00
###SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

#proteome_list=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/createdb_name
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
#f_name=$(sed -n ${idx}p $proteome_list)
#db_name=$(echo $f_name| cut -d '.' -f 1)


#cd ../result/
#run mmseqs
#mmseqs rbh ../../ecoli_data/ecoliDB ../alldata_db/$db_name "${db_name}rbh" tmp/$db_name --remove-tmp-files
mmseqs rbh ../../ecoli_data/ecoliDB ../../all_data/refproteomeDB ../whole_rbh ../tmp/refproteomeDB --remove-tmp-files
#convert the result
#mmseqs convertalis ../../ecoli_data/ecoliDB ../alldata_db/$db_name "${db_name}rbh" "${db_name}.m8"
