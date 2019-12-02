#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --array=1-5
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

#insert modules
ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15


#abspath
abspath=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/

#get the forward_blast file name 
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
ecoli_file=/home/j/juliezhu/pfs/data/ref_proteomes/ecoli_data/blastecoli
proteome_list=$abspath/proteome_list
pome_name=$(sed -n ${idx}p $proteome_list)
pname="${pome_name}_fw"

#length=95
length=$(wc -l < $abspath/blast_forward/$pname)
cd $abspath/blast_reverse/

#iteration: blast all 'target' proteins in the file
for i in `seq 1 $length`
#for i in `seq 90 $length`
do

#get the 'target' sequence id
qid=$(sed -n ${i}p $abspath/blast_forward/$pname | cut -d '	' -f2)

#find its corresponding file name
proteome_file=$(find ../../all_data/unzipped/ -name "${pome_name}*")
#find the sequence of id
pat1="^>${qid}.*"
pat2='^>.*'
#echo $pat1,$pat2
sequence=$(sed "1,/${pat1}/d;/${pat2}/,\$d" $proteome_file)
#echo $sequence

#create tmp file for single-sequence fa
id=$(grep $qid $proteome_file)
echo -e "${id}\n${sequence}" >> $abspath/tmp/${pome_name}_${i}.fa

#blast 
psiblast -query $abspath/tmp/${pome_name}_${i}.fa -db $ecoli_file -out $abspath/blast_reverse/${pome_name}_${i} -num_iterations 3 -evalue 0.01 -outfmt "6 qseqid sseqid qlen slen length qcovs pident qstart qend sstart send evalue"

#first check if the psiblast output is empty
if [ ! -s $abspath/blast_reverse/${pome_name}_${i} ]
then
	echo "${qid} db is empty." 
        continue
fi

#do the filtering
sed -i '/^Search.*/d;/^$/d' ${pome_name}_${i}
python ../bin/blast_mainfilter.py ${pome_name}_${i} backward
#echo ${pome_name}_${i}
cat "${pome_name}_${i}" >>"${pome_name}"
#delete the tmp file
rm $abspath/tmp/${pome_name}_${i}.fa
rm ${pome_name}_${i}
done

#for file in $(find . -name "${pome_name}*")
#do 
#cat "$file" >> "${pome_name}"
#rm $file
#done

