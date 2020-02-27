#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 4
#SBATCH -t 01:00:00
#SBATCH --array=1-565
#SBATCH --error=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/out/%A_%a.out

#insert modules
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

ecoli_file=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/ecoli_data/ecoliDB
proteome_list=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/proteome_list
pname=$(sed -n ${idx}p $proteome_list)
filename="${pname}_fw.m8"

## forward hits
cd ../forward/

mmseqs search ../../ecoli_data/ecoliDB ../../rbh_mmseqs/alldata_db/$pname $pname tmp/$pname --num-iterations 4 -s 5.7 --max-seqs 4000 --remove-tmp-files
mmseqs convertalis ../../ecoli_data/ecoliDB ../../rbh_mmseqs/alldata_db/$pname $pname $filename --format-output "query,target,pident,alnlen,qstart,qend,tstart,tend,qcov,tcov,evalue"

##run the forward filter 
python ../bin/mmseq_mainfilter.py $filename forward 
#echo 'forward hit done!'



## backward hits
##length of the loop: should be the same as the number of unique 'target' proteins in the forward_hit output. 
##get the unique 'target' sequence id
qid=$(cat $abspath/forward_trimmed/$filename | cut -d '	' -f2 | sort -u)

##get the fasta file of the proteome
proteome_file=$(find ../../all_data/unzipped/ -name "*${pname}*")

cd $abspath/backward/

#iteration: blast all 'target' proteins in the file

while IFS= read -r line
do

##find the sequence of the target protein $line
pat1=".*|${line}|.*"
pat2='^>.*'
#echo $pat1,$pat2
sequence=$(sed "0,/${pat1}/d;/${pat2}/,\$d" $proteome_file)

##find the info line of target protein $line
id=$(grep $line $proteome_file)
#echo $id
#echo $sequence

#save all sequences of hits in one proteome to a fa file.
echo -e "${id}\n${sequence}" >> $abspath/tmp/$pname.fa
done <<< "$qid"

###create mmseqs db for target proteins from forward files(saved in tmp folder)
mmseqs createdb $abspath/tmp/$pname.fa $abspath/tmp/$pname 
mmseqs createindex $abspath/tmp/$pname tmp/$pname --remove-tmp-files

## mmseqs iteratively
mmseqs search $abspath/tmp/$pname $ecoli_file $pname tmp/$pname --num-iterations 4 --remove-tmp-files -s 5.7 --max-seqs 4000
mmseqs convertalis $abspath/tmp/$pname $ecoli_file $pname "${pname}_bw.m8" --format-output "query,target,pident,alnlen,qstart,qend,tstart,tend,qcov,tcov,evalue"

# filter the backward file
python ../bin/mmseq_mainfilter.py ${pname}_bw.m8 backward
