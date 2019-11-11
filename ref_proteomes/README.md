# 2nd_project

- Try to set up a dataset which helps find the coevolution information between the query *E coli* proteome and other bacteria proteomes. 

- Paper: Protein interaction networks revealed by proteome coevlution (Qing) from David Baker group.

## details about files:

### snic_test.sh
A test bash script for dataset setting-up.

### dl_remainfiles.sh
A bash script to download the ungroupped files left from the batch jobs. Note that I have not set up any files for *stderr* in dev_file/.

### dl_emptyfiles.sh
A bash script to redownload the error files from the batch jobs. Details are in *dl_proteome.sh* section. Note that I have not set up any files for *stderr* in dev_file/.

### dl_proteome.sh
A bash script to submit the batch job to kebnekaise for downloading the reference proteomes from Uniprot. There are some requirements for this script:
- Before run this script, you have to make sure you have a full name list of the data in upper directory (format: *UP.....fasta.gz* line by line).
- The batch array size here is

```sh
$ SBATCH --array=1-50
```
so if you want to download many files, group your data by 50. For example, suppose you want to download 1624 files, you can run the following command:

```sh
$ for i in `seq 0 50 1550`; do sbatch dl_proteome.sh $i; done
```
This line could download the first 1600 files. 

- Then you need to run *dl_remainfiles.sh* to download the remained 24 files. 
- Empty files handling: According to the experience of downloading ref_proteome from Uniprot, downloading empty files is quite normal. So after finishing the above steps, re-downloading the error files is a must. First make sure that /dev_file/ is empty and then run *dl_emptyfiles.sh* to re-download the error files from the first try.And remember move all **.gz** files to your dataset folder.   
- *dl_proteome.sh* is designed for downloading files in the same dir. Normally, you should put it in your empty data folder before download.  If you want to download file to a different dir, remember to make changes on the script.

### error_list
A temporary file generated when running *dl_emptyfiles.sh*. 

### dl_loop.py
A py version of *dl_remainfiles.sh* just for testing.

## directory:

### all_data/
All the downloaded data files. (Might include *dl_proteome.sh*. check its existance before you count the files.)

### ecoli_data/
For *E coli* proteome & proteins.

### dev_file/
Save all STDOUT and STDERR files for the batch jobs.

### rbh/
reciprocal best hit procedure.
