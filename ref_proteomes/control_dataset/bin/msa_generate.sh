#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH --array=1-61
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/out/%A_%a.out

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

#load modules for python
ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15

idx=1
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
file=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/ecolippi_83333
line=$(sed -n ${idx}p $file)

pr1=$(echo $line | cut -d '|' -f1)
pr2=$(echo $line | cut -d '|' -f2)
#echo $pr1,$pr2
## mmseqs ortholog
#file1=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/ortholog/$pr1.fa
#file2=/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/ortholog/$pr2.fa

## blast ortholog
file1=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/ortholog/$pr1
file2=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/ortholog/$pr2

echo $file1 $fil2

if [[ -s $file1 && -s $file2 ]]; then
#	echo "right!"
       #run python code to make the matching lines for interacting pair(same lines are from the same proteome)
	python msa_generate.py $file1 $file2 $idx pos_bla
       #run blastdbcmd to retrieve sequences for homologs
        #cd ../homolog_seq/
        cd ../pos_blast/homolog_seq/
	blastdbcmd -db /home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/alldata_db/ref_db/refproteomeDB -entry_batch /home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/bla_tmp/${idx}_${pr1} -out ${idx}_${pr1}.fa
	blastdbcmd -db /home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/alldata_db/ref_db/refproteomeDB -entry_batch /home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/bla_tmp/${idx}_${pr2} -out ${idx}_${pr2}.fa	

#	echo 'blastdbcmd done!'
	#add ecoli sequence in the beginning of the homolog file
#	cat ../../seq_uniprot/$pr1.fasta ${idx}_${pr1}.fa > ${idx}_${pr1}.csv
#	mv ${idx}_${pr1}.csv ${idx}_${pr1}.fa
#	cat ../../seq_uniprot/$pr2.fasta ${idx}_${pr2}.fa > ${idx}_${pr2}.csv
#	mv ${idx}_${pr2}.csv ${idx}_${pr2}.fa

else
	echo "one or more is missing"
fi

