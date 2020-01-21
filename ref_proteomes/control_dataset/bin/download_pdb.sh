#!/bin/bash
#SBATCH -A SNIC2019-3-319
#SBATCH -c 5
#SBATCH -t 24:00:00
#####SBATCH --array=1-39
#SBATCH --error=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/error/%A_%a.error
#SBATCH --output=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/out/%A_%a.out

##OBS!
##because all interacting proteins in homolog_seq are saved with the same prefix number, like 10_P10000.fa and 10_P10001.fa, 
##so here the array will be half of the numbers of file in the homolog_seq. 

##get the argument from the input
if [ -z $1 ]
then
        offset=0
else
        offset=$1
fi

###original

#idx=16
#idx=$(expr $offset + $SLURM_ARRAY_TASK_ID)
#file=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/ecolippi_83333
#line=$(sed -n ${idx}p $file)

#get the filename
#string=$(echo $line| cut -d '|' -f3|cut -d ',' -f1)
#string=$(echo $line| cut -d '|' -f3)
#$echo $string
#filename=$(echo $string| cut -d '_' -f1)
#middle_name=${filename:1:2}
#chain=$(echo $string|cut -d '_' -f2)
#middlepoint=$(expr ${#chain} / 2)
#chainA=$(echo -n $chain | head -c $middlepoint)
#chainB=$(echo -n $chain | tail -c $middlepoint)
#$echo "This is middle name : ${middle_name}, thsi is chainA: ${chainA},this is chainB: ${chainB}"

#cd ../pdb_petras/
#wget ftp://ftp.wwpdb.org/pub/pdb/data/structures/divided/pdb/$middle_name/"pdb$filename".ent.gz

###download pdb according to the files in homolog_seqs/
### idx_1 & idx_2: interacting proteins.
file=/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/ecolippi_petrasTRIM

for SLURM_ARRAY_TASK_ID in `seq 1 39`;do
#SLURM_ARRAY_TASK_ID=12
idx_1=$((2*($offset+$SLURM_ARRAY_TASK_ID)-1))
idx_2=$(expr $idx_1 + 1)
echo $idx_1 $idx_2

#num_1: find the row idx of the protein in ecolippi_83333

fileA=$(ls ../homolog_seq/*.fa | sed -n ${idx_1}p)
fileB=$(ls ../homolog_seq/*.fa | sed -n ${idx_2}p)
echo $fileA $fileB
pr1=$(echo $fileA | cut -d '/' -f3 | cut -d '_' -f2 | cut -d '.' -f1)
pr2=$(echo $fileB | cut -d '/' -f3 |cut -d '_' -f2 | cut -d '.' -f1)
echo $pr1 $pr2
num=$(grep -n "${pr1}.*${pr2}\|${pr2}.*${pr1}" $file | cut -d ":" -f1)
pdb_entry=$(sed -n ${num}p $file | cut -d '|' -f3 | tr ',' ' ' )

cd ../pdb_petras 

##function check the existance of ftp path
function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'exists'` ]]; then echo 1;else echo 0; fi
}

for entry in $(echo $pdb_entry);do

pdbfile=$(echo $entry | cut -d '_' -f1)
echo $pdbfile
middle_name=${pdbfile:1:2}
chain=$(echo $string|cut -d '_' -f2)
middlepoint=$(expr ${#chain} / 2)
chainA=$(echo -n $chain | head -c $middlepoint)
chainB=$(echo -n $chain | tail -c $middlepoint)

echo $entry
norm_url="ftp://ftp.wwpdb.org/pub/pdb/data/structures/divided/pdb/${middle_name}/pdb${pdbfile}.ent.gz"
bund_url="ftp://ftp.wwpdb.org/pub/pdb/compatible/pdb_bundle/${middle_name}/${pdbfile}/${pdbfile}-pdb-bundle.tar.gz"
echo $norm_url $bund_url

##norm url exist
if [[ $(validate_url $norm_url) == 1 ]];then 
#wget -nc ${norm_url}
echo "${entry} norm_url is right"
#write the entry name used for this ppi in a file 
echo $pr1 $pr2 $entry >> ../ecolippi_pdb
break

##norm_url not exist but bund_url exist
elif [[ $(validate_url $bund_url) == 1 ]];then
#wget -nc ${bund_url}  
echo "${entry} bund_url is right"
#write the entry name used for this ppi in a file
echo $pr1 $pr2 $entry >> ../ecolippi_pdb
break

##neither urls exist
else
: 
fi
done

done
#function validate_url(){
#  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true";else echo "false"; fi
#}
