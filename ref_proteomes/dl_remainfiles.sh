#!/bin/bash

proteome_list=/home/j/juliezhu/pfs/data/ref_proteome_all
url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/

max_len=$(wc -l $proteome_list)
#ask the user for the begining idx
echo FROM\:\(index\)
read begin

# ask the user for the ending idx
echo TO\:\(index\)
read end

echo Patience is the key of success!

for i in `seq $begin $end`; 
do
f_name=$(sed -n ${i}p $proteome_list)
wget $url$f_name 
done 
