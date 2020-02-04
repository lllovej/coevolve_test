#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH --array=1-39
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/out/%A_%a.out


##this script should work after running jackhmme.sh and it includes two parts:
##the first part is to find the missing sequences in the jackhmmer process and trim them both in their original homolog fasta files and output msa files. so that the fasta files and msa files could match to each other. 
##the second part trys to merge the fasta seqs and a3m files for each interacting pairs and save the merged files to control_dataset/combined_data/

#load modules for python
ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15


##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

cd ../homolog_seq/

msa_path=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/msa_jackhmmer/
seq_path=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/homolog_seq/

SLURM_ARRAY_TASK_ID=39
idx_1=$((2*($offset+$SLURM_ARRAY_TASK_ID)-1))
idx_2=$(expr $idx_1 + 1)

pr1=$(ls *.fa | sed -n ${idx_1}p)
pr2=$(ls *.fa | sed -n ${idx_2}p)
#pr1="13_P0ABI8_test.fa"
#pr2="13_P0ABJ3_test.fa"
echo $pr1 $pr2

a3m_1="$(echo $pr1 | cut -d '.' -f1).a3m"
a3m_2="$(echo $pr2 | cut -d '.' -f1).a3m"
#a3m_1="13_P0ABI8_test.a3m"
#a3m_2="13_P0ABJ3_test.a3m"
echo $a3m_1 $a3m_2
cd ../bin

#echo $seq_path$pr1 $msa_path$a3m_1
python reorder_a3m.py $seq_path$pr1 $seq_path$pr2 $msa_path$a3m_1 $msa_path$a3m_2

#if [ $?="errors!" ];then 
#exit 1
#fi

###2nd part: paste
#1step: get the order from ecolippi_83333
##file: find the correct order of the protein interacting
##upseq: path for fasta seq(from uniprot) of ecoli proteins
file=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/ecolippi_petras
upseq=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/seq_uniprot/

##get the protein name 
pref_pr1=$(echo $pr1 | cut -d '.' -f1 | cut -d '_' -f2)
pref_pr2=$(echo $pr2 | cut -d '.' -f1 | cut -d '_' -f2)
##prf_pr1 eg: P10000

right_order=$(grep "${pref_pr1}.*${pref_pr2}\|${pref_pr2}.*${pref_pr1}" $file)
#echo $right_order
right_pr1=$(echo $right_order | cut -d '|' -f1)
right_pr2=$(echo $right_order | cut -d '|' -f2)
#right_pr1 eg: P10000
#right_pr1 represent protein 1 in right order(compatible with pdb chain) 

if [[ $pr1 == *"${right_pr1}"* ]];then
##if the pdb list has the same order as our name-> merge the msa and fasta
paste -d '' $msa_path$a3m_1 $msa_path$a3m_2 > ../combined_data/msa/${pref_pr1}_${pref_pr2}.a3m 
paste -d '' $upseq$pref_pr1.fa $upseq$pref_pr2.fa > ../combined_data/seq/${pref_pr1}_${pref_pr2}.fa
echo 'right order'
else
paste -d '' $msa_path$a3m_2 $msa_path$a3m_1 > ../combined_data/msa/${pref_pr2}_${pref_pr1}.a3m
paste -d '' $upseq$pref_pr2.fa $upseq$pref_pr1.fa > ../combined_data/seq/${pref_pr2}_${pref_pr1}.fa
echo 'wrong order'
fi


#cd ../msa_jackhmmer/
#paste -d ''


#paste -d '' $a3m_1 $a3m_2 > ../combined_data/msa/${pr1}_${pr2}.a3m
          
