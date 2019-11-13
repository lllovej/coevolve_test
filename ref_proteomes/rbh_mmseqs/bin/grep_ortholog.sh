#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 12:00:00
#SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

proteomelist=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/createdb_name
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
p_name=$(sed -n ${idx}p $proteomelist)
pref=$(echo $p_name | cut -d '.' -f 1)
p_name="$pref.m8"


cd ../ortholog/
#get how many hits in this proteome
length=$(wc -l < ../after_parse/$p_name)

#for each hit, find its query ecoli protein and append this line to the corresponding ortholog group.
for i in `seq 1 $length`
do
qid=$(sed -n ${i}p ../after_parse/$p_name | cut -d '	' -f1)
ol_file=$(find . -maxdepth 1 -name "*$qid*" -print)
line=$(sed -n ${i}p ../after_parse/$p_name)
echo "$line" >> "$ol_file"
done
