#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
#SBATCH -t 24:00:00
###SBATCH --array=1-78
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

#load modules for hmmer
ml icc/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
ml ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
ml HMMER/3.2.1

cd ../homolog_seq/inc_ecoli
idx=1
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
filename=$(ls -1 | sed -n ${idx}p)
#filename is like 1_P10000.fa
prefix=$(echo $filename | cut -d '.' -f1)
#echo $prefix
#prefix is like 1_P10000
idname=$(echo $prefix | cut -d '_' -f2)
#idname is like P10000

##benchmark 
##jackhmmer highE lowN
#jackhmmer  -N 1 -A ../msa_jackhmmer/heln/${prefix}.sto ../seq_uniprot/${idname}.fasta $filename 
##jackhmmer highE highN
#jackhmmer -N 3 -A ../msa_jackhmmer/hehn/${prefix}.sto ../seq_uniprot/${idname}.fasta $filename 

##jackhmmer lowE highN
#jackhmmer -N 3 -E 0.001 --incE 0.001 -A ../msa_jackhmmer/lehn/${prefix}.sto ../seq_uniprot/${idname}.fasta $filename 

##jackhmmer lowE lowN
#jackhmmer -N 1 -E 0.001 --incE 0.001 -A ../msa_jackhmmer/leln/${prefix}.sto ../seq_uniprot/${idname}.fasta $filename 

#cd ../msa_jackhmmer/


##reformat from sto to a3m
#/home/j/juliezhu/pfs/data/hhsuite2/scripts/reformat.pl ${prefix}.sto ${prefix}.a3m

##one line
#echo "$(awk '/^>/{print a;a="";print;next}{a=a$0}END{print a}' ${prefix}.a3m )" > ${prefix}.a3m
#sed -i '1d' {prefix}.a3m

##reorder
#python 








##clustalOmega to generate MSA
clustalo -i $filename -o ../../msa_clustalo/clu/${prefix}.clu --outfmt=clu -v --threads=14
#clustalo -i $filename -o ../msa_clustalo/${prefix}.clu --outfmt=clu -v --threads=14
##horizontally concatenate the interacting pairs to one big MSA
##combine two msa when it has odd idx, skip when it has even idx. 
#cd ../msa_clustalo/
##idx=1
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
#filename=$(ls -1 | sed -n ${idx}p)
#if [ $(( idx % 2 )) -eq 0 ];
#then
#    echo "even";
#else
#    ##combine the #idx and #idx+1 msa.
#    nextfile=$(ls -1 | sed -n $(( idx + 1 ))p)
#    num=$(echo $nextfile | cut -d '_' -f1)
#    paste -d '' $filename $nextfile > combo_${num}.a3m   
#fi
