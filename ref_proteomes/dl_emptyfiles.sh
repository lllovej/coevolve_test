#!/bin/bash

#proteome_list=/home/j/juliezhu/pfs/data/ref_proteome_all
#url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/

cd dev_file/
grep -l 'initiate' *.error | xargs grep -oh 'UP.*gz' | awk '!a[$0]++' > ../error_list

url=ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/

cd ../
while IFS= read -r line; 
do
#f_name=$(sed -n ${i}p $proteome_list)
wget $url$line 

done < error_list


