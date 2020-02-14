# File description

- create_blastdb.sh
Run *makeblastdb* to create blast-format database. This script works for all reference proteomes data.

- blast_forward.sh / blast_backward.sh
Reproduce the 'reciprocal best hit' process. *Forward* means using ecoli proteome as the queryDB and other ref proteomes are the targetDB. *Backward* means the opposite direction. For *blast_forward.sh*, the script simply includes *psiblast* with 3 iterations, and result filtering(remove the redundant items using `blast_mainfilter.py`). For *blast_backward.sh*, the script needs more steps: 

for each proteome->first, get the forward psiblast result from previous script, cut off the hit column and keep the uniq hits; then go back to its proteome sequence file and get sequences for those hits (save to *fa* file in /tmp); run *psiblast* for this fa file against ecoli proteome to get the backward hits; next remove the empty lines or message lines and run `blast_mainfilter.py` to filter the results.

- ortholog.sh & ortholog.py
for each proteome, based on its forward hits and backward hits and get the intersection. And save the psiblast output records in $recipro_hit$ folder. 

- parse_blast.sh & parsing_blast.py
After the *ortholog.sh* process, we need to make sure that each ecoli has one ortholog in each proteome. Thus these two scripts take the files from $recipro_hit$ as input, and save the trimmed data in `after_parse`.The blast parsing is more complicated than mmseqs parsing. For example, for the similar hits, the start position and the end position might have very few residues difference. (sta 1 end 5 and sta 2 end 6). So here I set the criteria as: if two hits are overlapped more than 80%, they are regarded as duplicates and the one with lower e-value would be kept. But in my case, if two diffent ecoli match same protein with different regions, I will not consider these two hits anymore(which will be saved in $after_parse/manual/$). Details about this step is on 19p and 20p of the SI of the paper. 

- grep_ortholog.sh
grep orthologs for each ecoli protein. Remember that I add one column after the *psiblast* record for which proteome this hit comes from. So that it would easy to manipulating the matching MSA later.
