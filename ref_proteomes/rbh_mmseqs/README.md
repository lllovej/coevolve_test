# mmseqs folder

## A folder stores all results using mmseqs cmd. 

### createdb_name
A name list of all 6565 ref_proteomes: single column with a format like `UP000002010_557598.fasta`.

### test.sh
Test bash script for any random testing.

## dir

### alldata_db
Output mmseqs-readable Database with script `createdb.sh` in $bin/$. Each db has eight files.

### result
Output mmseqs rbh result with script `rbh_process.sh`.  Each db has 4 files.

### after_parse
Remove the multiple hits so that we have one orthlog per Ecoli protein. In practice `parse_mmseqs.sh` and `parsing_mmseqsrbh.py` trim the data in $result$. There is a subdir named `manual`, which stores the complicated case that the script could not handle. 

### error & out
save `STDOUT` and `STDERR` of the scripts in $bin/$.

### ortholog
Orthlog groups of all ecoli proteins. Each ecoli proteins has its own file, which contains all its hits from all the target proteomes. 
