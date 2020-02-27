import pandas as pd
import numpy as np
import os,sys

def main():
    #import the file.Here file1&2 both includes the abs path. idx is the index prefix of the output. 
    #opt is that you decide the output path: there are three paths: 
    #pos_ctr: positive control dataset(39 interacting pairs); neg_ctr: negative control dataset(39000 none-interacting pairs); neg_test(39*38/2 none-interacting pairs from positive control dataset.)
    file1 = sys.argv[1] 
    file2 = sys.argv[2]
    idx = sys.argv[3]
    opt = sys.argv[4]

##for blast output
    pr1 = file1.split('/')[-1]
    pr2 = file2.split('/')[-1]
##for mmseqs output
#    pr1 = file1.split('/')[-1].split('.')[-2]
#    pr2 = file2.split('/')[-1].split('.')[-2]

    df1=pd.read_csv(file1,header=None,delimiter='\t')
    df2=pd.read_csv(file2,header=None,delimiter='\t')
    
    df3=pd.merge(df1,df2,on=[12])
    
    if opt == 'pos_ctr':
##positive mmseqs dataset
       df3['1_x'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/tmp/'+idx+'_'+pr1,header=None,index=None)
       df3['1_y'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/tmp/'+idx+'_'+pr2,header=None,index=None)

    elif opt == 'pos_bla':
##positive blast dataset
       df3['1_x'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/bla_tmp/'+idx+'_'+pr1,header=None,index=None)
       df3['1_y'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/bla_tmp/'+idx+'_'+pr2,header=None,index=None)

    elif opt == 'neg_bla':
##netative blast dataset
       df3['1_x'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/bla_negtmp/'+idx+'_'+pr1,header=None,index=None)
       df3['1_y'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/bla_negtmp/'+idx+'_'+pr2,header=None,index=None)

    elif opt == 'neg_ctr':
##negative dataset
       df3['1_x'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/nega_control/tmp/'+idx+'_'+pr1,header=None,index=None)
       df3['1_y'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/nega_control/tmp/'+idx+'_'+pr2,header=None,index=None)

    elif opt == 'neg_test':
##negative testset
       df3['1_x'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/nega_test/tmp/'+idx+'_'+pr1,header=None,index=None)
       df3['1_y'].to_csv('/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/control_dataset/nega_test/tmp/'+idx+'_'+pr2,header=None,index=None)
    else:
       print('wrong opt input!')

if __name__== "__main__":
    main()
