import pandas as pd
import sys

##proteome namelist path
#namelist_path='/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/proteome_list'
#save path

save_path='/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/after_parse/'

#with open(namelist_path,'r') as f:
#     proteomelist=f.readlines()
#     proteomelist=[x.strip() for x in proteomelist]

#for i in proteomelist:

i=sys.argv[1]

fw='/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/forward_trimmed/'+i+'_fw.m8'	
bw='/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_mmseqite/backward_trimmed/'+i+'_bw.m8'

df_for=pd.read_csv(fw,sep='\t',header=None)
df_for.columns=['query','target','pident','alnlen','qstart','qend','tstart','tend','qcov','tcov','evalue'] 

df_bac=pd.read_csv(bw,sep='\t',header=None)
df_bac.columns=['query','target','pident','alnlen','qstart','qend','tstart','tend','qcov','tcov','evalue']
	
pd.merge(df_for, df_bac, left_on=['query','target'], right_on=['target','query']).iloc[:,:11].to_csv(save_path+i,header=None,index=None,sep='\t')
