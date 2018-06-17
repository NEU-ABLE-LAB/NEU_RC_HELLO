#!/bin/bash
#SBATCH --job-name=slurm_matlab_test
#################
#stdout file for the script below
#You can check job progress with the 
#shell command `tail`
#SBATCH --output=out/sbatch.out
#################
#stderr file for the script below
#SBATCH --error=out/sbatch.err
#################
#number of tasks you are requesting
#SBATCH -n 8
#################
#partition to use
#SBATCH --partition=ser-par-10g-4
#SBATCH --exclusive
#################
#number of nodes to distribute n tasks across
#SBATCH -N 1
#################

# The directory the contains the sbatch and Matlab scripts
run_dir="/home/$USER/devel/NEU_RC_TEST/matlab/"

# The directory to read and write data
# Large input and output data should be stored in /gss_gpfs_scratch/ since each user has a 30 GByte quota (hard limit) and 20 GByte soft limit on the `/home/` directory. /gss_gpfs_scratch/ does not have quotas enabled. Consistently using over ~1TB of scratch space for two or more weeks at a time is not permitted. Since this space is limited to 1.1PB and we have more than 500 users please make sure you “rsync” or “sFTP” your data elsewhere. See https://www.northeastern.edu/rc/?page_id=2
data_dir="/gss_gpfs_scratch/$USER/paralleldemo_parfor_bench/`date +%Y%m%d_%H%M%S`/"

# The directory to write output logs
log_dir="/home/$USER/devel/NEU_RC_TEST/matlab/out/`date +%Y%m%d_%H%M%S`/"

# Create the directories if they do not exist.
mkdir -p $run_dir
mkdir -p $data_dir
mkdir -p $log_dir

cd $run_dir

matlab -logfile ./out/output.txt -nodisplay -r "paralleldemo_parfor_bench('$log_dir','$data_dir')"