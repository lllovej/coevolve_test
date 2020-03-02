# File Description

- createdb.sh
Create mmseqs database, and also create the index files(accoring to the SI, the last command line of Table 3).

- mmseq_rbh.sh
Use mmseqs iterative search(FLAG `--num-iterations 4 -s 5.7 --max-seqs 4000` from SI, the last command line of Table 3) for reciprocal best hit process. `mmseq_mainfilter.py` is used for the filtering process of rbh. The resulting hits are in `forward_trimmed/` and `backward_trimmed/` folders.

- ortholog.sh
There are three parts in this script: 

a. get the intersection of forward hits and backward hits of a proteome. This is achieved by `intersec_fwbw.py` and the output are saved in `after_parse/`.(Note that in `rbh_blast` and `rbh_mmseqs`, there is a separate folder `recipro_hit` to save the output of this step, but this time I save directly in `after_parse` and later trimm them in place.)

b. make sure that each ecoli has one hit in each proteome. This is achieved by `parsing_blast.py`: the script operates the previous file in place in `after_parse/`.

c. grep orthologs for each ecoli protein and save output in `ortholog/`. 
