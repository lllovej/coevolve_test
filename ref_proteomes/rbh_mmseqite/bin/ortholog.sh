#! /bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH --array=1-1000
#SBATCH --error=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/error/%A_%a.error
#SBATCH --out=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/out/%A_%a.out

#load modules
ml GCC/8.2.0-2.31.1  OpenMPI/3.1.3 ADIOS2/2.5.0-Python-3.7.2

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

#idx=1
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
abspath=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite
proteome_list=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/proteome_list
pname=$(sed -n ${idx}p $proteome_list)

#python intersec_fwbw.py $pname
#python parsing_blast.py $pname

cd ../ortholog/
length=$(wc -l < ../after_parse/$pname)
for i in `seq 1 $length`
do
qid=$(sed -n ${i}p ../after_parse/$pname | cut -d '	' -f1)
ol_file=$(find . -maxdepth 1 -name "*$qid*" -print)
line=$(sed -n ${i}p ../after_parse/$pname)
echo "$line	$pname" >> "$ol_file"
done

