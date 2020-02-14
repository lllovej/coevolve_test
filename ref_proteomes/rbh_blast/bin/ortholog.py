import pandas as pd

#proteome namelist path
namelist_path='/home/j/juliezhu/pfs/coevolve_refome/ref_proteomes/rbh_blast/proteome_list'
#save path
save_path='/home/j/juliezhu/pfs/coevolve_refome/ref_proteomes/rbh_blast/recipro_hit/'

with open(namelist_path,'r') as f:
     proteomelist=f.readlines()
     proteomelist=[x.strip() for x in proteomelist]

for i in proteomelist:
    fw='/home/j/juliezhu/pfs/coevolve_refome/ref_proteomes/rbh_blast/blast_forward/'+i+'_fw'	
    bw='/home/j/juliezhu/pfs/coevolve_refome/ref_proteomes/rbh_blast/blast_backward/'+i+'_bw'

    df_for=pd.read_csv(fw,sep='\t',header=None)
    df_for.columns=['qseqid','sseqid','qlen','slen','length','qcovs','pident','qstart','qend','sstart','send','evalue'] 

    df_bac=pd.read_csv(bw,sep='\t',header=None)
    df_bac.columns=['qseqid','sseqid','qlen','slen','length','qcovs','pident','qstart','qend','sstart','send','evalue']
	
    pd.merge(df_for, df_bac, left_on=['qseqid','sseqid'], right_on=['sseqid','qseqid']).iloc[:,:12].to_csv(save_path+i,header=None,index=None,sep='\t')
