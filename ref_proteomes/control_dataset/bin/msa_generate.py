import pandas as pd
import numpy as np
import os,sys

def main():
    #import the file.Here file1&2 both includes the abs path. 
    file1 = sys.argv[1] 
    file2 = sys.argv[2]
    idx = sys.argv[3]
    
    pr1 = file1.split('/')[-1].split('.')[-2]
    pr2 = file2.split('/')[-1].split('.')[-2]

    df1=pd.read_csv(file1,header=None,delimiter='\t')
    df2=pd.read_csv(file2,header=None,delimiter='\t')
    
    df3=pd.merge(df1,df2,on=[12])
    df3['1_x'].to_csv('/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/tmp/'+idx+'_'+pr1,header=None,index=None)
    df3['1_y'].to_csv('/home/j/juliezhu/pfs/data/ref_proteomes/control_dataset/tmp/'+idx+'_'+pr2,header=None,index=None)

if __name__== "__main__":
    main()
