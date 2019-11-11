#!/bin/bash -l

#get the dir of name list
proteome_list=/home/j/juliezhu/pfs/data/ref_proteome_all

nl_len=$(wc -l < $proteome_list)
cmd_str=''
#echo $nl_len
for i in $(seq 1 $nl_len)
do 
	f_name=$(sed -n ${i}p $proteome_list)
	cmd_str=$cmd_str' '$f_name
#	if i<10;then
#		echo $cmd_str
#	fi
done 

cd ref_proteomes/all_data
mmseqs createdb $cmd_str refproteomeDB
