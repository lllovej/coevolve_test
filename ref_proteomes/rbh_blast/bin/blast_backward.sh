#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

#load modules
ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15


#abspath
abspath=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_blast/

#get the forward_blast file name 
#idx=2
idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
ecoli_file=/home/j/juliezhu/pfs/data/ref_proteomes/ecoli_data/blastecoli
proteome_list=$abspath/proteome_list
pome_name=$(sed -n ${idx}p $proteome_list)
pname="${pome_name}_fw"

#length of the loop: should be the same as the number of unique 'target' proteins in the forward_hit output. 
#get the unique 'target' sequence id
qid=$(sed -n ${i}p $abspath/blast_forward/$pname | cut -d '	' -f2 | sort -u)

#get the fasta file of the proteome
proteome_file=$(find ../../all_data/unzipped/ -name "*${pome_name}*")

cd $abspath/blast_reverse/

#iteration: blast all 'target' proteins in the file

while IFS= read -r line
do
#echo $line

##find the sequence of the target protein $line
pat1="^>${line}.*"
pat2='^>.*'
#echo $pat1,$pat2
sequence=$(sed "0,/${pat1}/d;/${pat2}/,\$d" $proteome_file)

##find the info line of target protein $line
id=$(grep $line $proteome_file)
#echo $id
#echo $sequence

#save all sequences of hits in one proteome to a fa file.
echo -e "${id}\n${sequence}" >> $abspath/tmp/${pome_name}.fa
done <<< "$qid"

##blast 
psiblast -query $abspath/tmp/${pome_name}.fa -db $ecoli_file -out $abspath/blast_reverse/${pome_name} -num_iterations 3 -evalue 0.01 -outfmt "6 qseqid sseqid qlen slen length qcovs pident qstart qend sstart send evalue"

##first check if the psiblast output is empty
#if [ ! -s $abspath/blast_reverse/${pome_name}_${i} ]
#then
#	#echo "${qid} db is empty." 
#       rm $abspath/blast_reverse/${pome_name}_${i}
#	rm $abspath/tmp/${pome_name}_${i}.fa
#	continue
#fi

##do the filtering
sed -i '/^Search.*/d;/^$/d' ${pome_name}
python ../bin/blast_mainfilter.py ${pome_name} backward
