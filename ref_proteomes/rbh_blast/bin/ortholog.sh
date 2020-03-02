#SBATCH -A SNIC2019-3-319
#SBATCH -c 1
#SBATCH -t 04:00:00
#SBATCH --error=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/error/%A_%a.error
#SBATCH --out=/home/j/juliezhu/pfs/coevolve_1st/ref_proteomes/rbh_blast/out/%A_%a.out

#load modules
ml GCC/7.3.0-2.30  CUDA/9.2.88  OpenMPI/3.1.1 pandas-plink/1.2.30-Python-2.7.15

python ortholog.py
