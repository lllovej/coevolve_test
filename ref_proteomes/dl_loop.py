import os
import subprocess


def main():
    proteome_list = "/home/j/juliezhu/pfs/data/ref_proteome_all"
    url = "ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/"
    for i in range(10):
        f_name = subprocess.check_output(["sed -n " + str(i + 1) + "p " + proteome_list],shell=True)
        #os.system("wget "+url+f_name)
        cmd='wget '+url+str(f_name)
	subprocess.check_output([cmd],shell=True)
	#print("wget "+url+str(f_name))
if __name__=="__main__":
    main()
