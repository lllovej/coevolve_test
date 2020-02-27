#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
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

#load modules
ml GCC/8.2.0-2.31.1  OpenMPI/3.1.3 ADIOS2/2.5.0-Python-3.7.2

#abspath
abspath=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite

#get the forward_blast file name 
#idx=1
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
ecoli_file=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/ecoli_data/ecoliDB
proteome_list=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/proteome_list
pome_name=UP000198418_1074
#pome_name=$(sed -n ${idx}p $proteome_list)
pname="${pome_name}_fw.m8"

#length of the loop: should be the same as the number of unique 'target' proteins in the forward_hit output. 
#get the unique 'target' sequence id
qid=$(cat $abspath/forward_trimmed/$pname | cut -d '	' -f2 | sort -u)

#get the fasta file of the proteome
proteome_file=$(find ../../all_data/unzipped/ -name "*${pome_name}*")

cd $abspath/backward/

#iteration: blast all 'target' proteins in the file

while IFS= read -r line
do
#echo $line

##find the sequence of the target protein $line
pat1=".*|${line}.*"
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

##create mmseqs db for target proteins from forward files(saved in tmp folder)
mmseqs createdb $abspath/tmp/$pome_name.fa $abspath/tmp/$pome_name
mmseqs createindex $abspath/tmp/$pome_name tmp/$pome_name --remove-tmp-files

## mmseqs iteratively
mmseqs search $abspath/tmp/$pome_name $ecoli_file $pome_name tmp/$pome_name --num-iterations 4 --remove-tmp-files
mmseqs convertalis $abspath/tmp/$pome_name $ecoli_file $pome_name "${pome_name}_bw.m8" --format-output "query,target,pident,alnlen,qstart,qend,tstart,tend,qcov,tcov,evalue"

# filter the backward file
python ../bin/mmseq_mainfilter.py ${pome_name}_bw.m8 backward
