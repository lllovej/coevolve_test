### folder description

## createdb.sh
create $mmseqs$ format database for all target proteomes.

## rbh_process.sh
run $reciprocal best hit procedure$ using mmseqs and converting the output to $m8$ format. Query DB is `ecoliDB` (ref_proteomes/ecoli_data/) and target DB is all the reference proteomes(rbh_mmseqs/alldata_db).

## parse_mmseqs.sh and parsing_mmseqsrbh.py
Apply a criteria to the outputs(rbh_mmseqs/result) from `rbh_process.sh`: remove multiple records regarding both query ecoli proteins and target proteins, so that one ecoli query protein has one pure ortholog within each proteome.

## grep_ortholog.sh
For each ecoli protein, find its hits in all the proteomes and save them as an individual ortholog group in `rbh_mmseqs/ortholog`. 
