import pandas as pd
#import numpy as np
#import matplotlib.pyplot as plt
import os
import sys

def main():
    #import the files.	
    file=sys.argv[1]
    #file='test.m8'
    #absolute path    
    abs_m8='/home/j/juliezhu/pfs/data/ref_proteomes/rbh_mmseqs/after_parse/'
		
    df = pd.read_csv(file, delimiter='\t', header=None)
    df.columns = ['Qid', 'Tid', 'SI', 'aliLEN', 'mismatch', 'gap', 'q_sta', 'q_end', 't_sta', 't_end', 'evalue',
                      'bitscore']
    # apply evalue criteria
    df = df[df['evalue'] <= 0.01]

    #set up an empty df for complicated cases: do it manually
    manual_df = pd.DataFrame()

    #if df has multiple records
    if len(df[df.duplicated(subset='Tid', keep=False)]) != 0:
        df,manual_df = multiTarget_trimming(df, manual_df)

    if len(df[df.duplicated(subset='Qid', keep=False)]) != 0:
        df, manual_df = multiQuery_trimming(df, manual_df)

    #save new df as the final csv.

    # df.to_csv(proteome+'.m8')
    df.to_csv(abs_m8+file,header=False,sep='\t',index=False)

    #check if manual_df is empty or not
    if not manual_df.empty:
       manual_df.to_csv(abs_m8+'manual/'+file,header=False,sep='\t',index=False)


def multiTarget_trimming(df,manual_df):
    '''
    remove the multiple records and resulting in a file where each target protein has one ecoli hit.
    '''

    # remove target proteins which has more than 3 hits. since only two records are accepted. Becase if there were still more than oen candidate in a species after the redundancy
    #removal and the merging partial hits, the protein should be excluded.

    df_dropt = df.groupby('Tid', sort=False).filter(lambda x: len(x) >= 3)
    df = df.drop(index=df_dropt.index)

    #get target proteins with two ecoli hits and groupby 'Tid'.
    g1 = df[df.duplicated(subset='Tid', keep=False)].sort_values('evalue').groupby('Tid', sort=False)
    g1_name = [name for name, ff in g1]

    #continue the trimming process only if g1 is not empty.
    if g1_name == []:
        return df,manual_df

    #For each group, apply our criteria: for the target protein, if the alignments of two hits are in the same region,
    # take the ecoli protein with longer alignment. Otherwise, do the trimming manually(manual_df).
    for i in g1_name:
        g1_df = g1.get_group(i)
        sta1, end1 = g1_df.iloc[0]['t_sta'], g1_df.iloc[0]['t_end']
        sta2, end2 = g1_df.iloc[1]['t_sta'], g1_df.iloc[1]['t_end']
        range1, range2 = set(range(sta1, end1)), set(range(sta2, end2))
        # second item includes the first one: drop 1st
        if list(range1 - range2) == []:
            df = df.drop(index=g1_df.index[0])
        # first item includes the second one: drop 2nd
        elif list(range2 - range1) == []:
            df = df.drop(index=g1_df.index[1])
        # intersection or no-overlap at all: drop from the result and do it manually
        else:
            df = df.drop(index=g1_df.index)
            manual_df = manual_df.append(g1_df)



    return df, manual_df



def multiQuery_trimming(df, manual_df):
    '''
    remove the multiple records and resulting in a file where each ecoli query protein has one hit.
    '''
    # remove ecoli proteins which has more than 3 hits. since only two records are accepted. Becase if there were still more than oen candidate in a species after the redundancy
    #removal and the merging partial hits, the protein should be excluded.oved.
    df_dropq = df.groupby('Qid', sort=False).filter(lambda x: len(x) >= 3)
    df = df.drop(index=df_dropq.index)

    # get ecoli proteins with two target hits and groupby 'Qid'.
    g2 = df[df.duplicated(subset='Qid', keep=False)].sort_values('evalue').groupby('Qid', sort=False)
    g2_name = [name for name, ff in g2]

    if g2_name==[]:
        return df,manual_df

    # For each group, apply our criteria: for the ecoli protein, if the alignments of two hits are in the same region,
    # take the target protein with longer alignment. Otherwise, do the trimming manually(manual_df).
    for j in g2_name:
        g2_df = g2.get_group(j)
        sta1, end1 = g2_df.iloc[0]['q_sta'], g2_df.iloc[0]['q_end']
        sta2, end2 = g2_df.iloc[1]['q_sta'], g2_df.iloc[1]['q_end']
        range1, range2 = set(range(sta1, end1)), set(range(sta2, end2))
        if list(range1 - range2) == []:
            df = df.drop(index=g2_df.index[0])
        # first item includes the second one: drop 2nd
        elif list(range2 - range1) == []:
            df = df.drop(index=g2_df.index[1])
        # intersection or no-overlap at all: drop from the result and do it manually
        else:
            df = df.drop(index=g2_df.index)
            manual_df = manual_df.append(g2_df)

    return df, manual_df

if __name__== "__main__":
   main()

