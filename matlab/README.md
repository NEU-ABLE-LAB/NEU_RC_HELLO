# MATLAB Hello World on Discovery
This is a MATLAB `parfor` demo running on the NEU Discovery Cluster. This example benchmarks the `parfor` construct by repeatedly playing the card game of blackjack, also known as 21. We use `parfor` to play the card game multiple times in parallel, varying the number of MATLAB® workers, but always using the same number of players and hands. This example is based on the [Simple Benchmarking of PARFOR Using Blackjack](https://www.mathworks.com/help/distcomp/examples/simple-benchmarking-of-parfor-using-blackjack.html) from the MATLAB [Parallel Computing Toolbox Examples](https://www.mathworks.com/help/distcomp/examples.html).

***NOTE*** -- At this time (July 2018) MATLAB can only be run in parallel on a single node, i.e. across the physical (*not* logical) cores of that node. If you need to run jobs on multiple nodes, you may submit a request to ITS for Matlab MDCS license.

- [MATLAB Hello World on Discovery](#matlab-hello-world-on-discovery)
  * [1. Using MATLAB for the first time on Discovery](#1-using-matlab-for-the-first-time-on-discovery)
  * [2. Using an Interactive MATLAB node](#2-using-an-interactive-matlab-node)
  * [3. Running MATLAB in Parallel using `parfor`](#3-running-matlab-in-parallel-using--parfor-)
    + [3a. Configure Matlab to use the cluster](#3a-configure-matlab-to-use-the-cluster)
    + [3b. Create and run a SLURM job.](#3b-create-and-run-a-slurm-job)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

A summary of these commands is available in the [Matlab Discovery Cheat sheet](cheatsheet.md)

## 1. Using MATLAB for the first time on Discovery
Before you begin: become familiar with high-performance computing at Northeastern on the Discover cluster by reading through the [Research Computing website](https://its.northeastern.edu/researchcomputing/), particularly the [Overview](https://its.northeastern.edu/researchcomputing/overview/) and [Guidelines](https://its.northeastern.edu/researchcomputing/usage-guidelines/).

1) Request an account through [ServiceNow](https://northeastern.service-now.com/research?id=sc_cat_item&sys_id=0ae24596db535fc075892f17d496199c).

2) Follow the directions to [connect to Discovery Cluster](https://its.northeastern.edu/researchcomputing/connecting/)

    * If you are new to all of this and using Windows, I recommend using the following: 
        * [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) Download the full Putty installer.
        * [XMing](https://sourceforge.net/projects/xming/)
        * [Filezilla](https://filezilla-project.org/download.php?type=client)
        * [Notepad++](https://notepad-plus-plus.org/) with the [NppFTP](https://sourceforge.net/projects/nppftp/) plug-in.

        Configure Putty, XMing, and Notepad++ FTP with profiles to easily connect to Discovery.
        
        TODO -- separate this out into its own page and provide instructions for using SSH keys. Also explain X11.

3) Getting Matlab to run on Discovery

    * Discovery is not just one computer, but a cluster of many computers. A program called SLURM is used to distribute the compute jobs to the appropriate computer(s) on the cluster. Before we can use Matlab, we need to configure SLURM with the appropriate "modules". Open the file `/home/[YOUR USERNAME]/.bashrc` with [NppFTP](https://sourceforge.net/projects/nppftp/) or via an SSH command window with [`nano`](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/) or [`vi`](https://www.howtogeek.com/102468/a-beginners-guide-to-editing-text-files-with-vi/) and append the following. Explanation of this use of the `.bashrc` file can be found on the [RC software page](https://its.northeastern.edu/researchcomputing/software/).

        ```bash
        # User specific aliases and functions
        #####################################
        
        # Prerequisites for Matlab
        None required
        
        module load matlab/R2018a
        ```
        
    After changing your `.bashrc` file, log out and log back in.
				
## 2. Using an Interactive MATLAB node
Create an interactive node for Matlab. 

## 3. Running MATLAB in Parallel using `parfor`

### 3a. Configure Matlab to use the correct nodes on the cluster.

1) Using the Matlab GUI over X11 can be slow. To help speed it up, run the following shell command \[[H/T](https://www.mathworks.com/matlabcentral/answers/107239-why-does-r2013b-keyboard-freeze-when-toggling-x11-forwarded-windows)\]:

    ```bash
    $ echo "-Dsun.java2d.pmoffscreen=false" > ~/java.opts
    ```
    
    You should only need to run this command once, ever.

2) Run Matlab. Make sure that you have XMing running on your local machine. You should see the XMing icon in your system tray.

    ```bash
    $ matlab -softwareopengl
    ```
            
    Matlab should now be running through X11 on your computer.
    
    *NOTE*: Only some partitions have the libraries for Matlab GUI. If you receive an error about `error: /usr/lib64/libGL`, select another partition or [contact research computing](https://its.northeastern.edu/researchcomputing/contact/). Alternatively, you can use the following command to start Matlab below `$ matlab -softwareopengl`.
    
3) Verify this Cluster configuration using the default `local` profile.

    ```matlab
    > parpool('local')
    ```
    
    Should return the following
    
    ```
    Starting parallel pool (parpool) using the 'local' profile ... connected to 12 workers.

    ans = 

     Pool with properties: 

                Connected: true
               NumWorkers: 12
                  Cluster: local
            AttachedFiles: {}
              IdleTimeout: 30 minute(s) (30 minutes remaining)
              SpmdEnabled: true
    ```
    
    Assuming you are using the X11 MATLAB GUI, you can further validate the local cluster profile [following these directions](https://www.mathworks.com/help/distcomp/discover-clusters-and-use-cluster-profiles.html#brrzq8d-1).

### 3b. Create and run a SLURM job. 
Instead of creating an interactive node every time you want to run a Matlab script/function, you can queue a SLURM job to run the script when the necessary resources become available on the cluster. 

The Matlab [`parfor`](https://www.mathworks.com/help/distcomp/parfor.html) command makes it simple to parallelize Matlab computations that would otherwise occur in serial with the `for` command. 

1) Download the files for this test by running the following Git command.

    ```bash
    $ cd $HOME
    $ mkdir -p devel/NEU_RC_TEST
    $ cd devel/NEU_RC_TEST
    $ git clone git@github.com:NEU-ABLE-LAB/NEU_RC_TEST.git
    $ cd matlab
    ```
    
    Explanation of command:
    * Changes the directory to `/home/[YOUR USERNAME]`
    * Creates the directory `devel/` (if it does not already exists) where you should keep all of your code development projects, and then the `NEU_RC_TEST/` directory for this Git repository.
    * Changes the directory to `devel/NEU_RC_TEST/`
    * Clones the Git repository at `github.com:NEU-ABLE-LAB/NEU_RC_HELLO` to the `NEU_RC_TEST/` directory.
    * Changes the directory to `matlab/` containing the Matlab RC test demo.
    
    This should create the following files in the `matlab/` directory.
    
    * **`paralleldemo_parfor_bench.sbatch`** -- SLURM will execute the contents of this batch script.        
    * **`paralleldemo_parfor_bench.m`** -- This Matlab function is called by the SLURM batch script.   
    * `pctdemo_aux_parforbench` -- Uses parfor to play blackjack. 
    * `pctdemo_setup_blackjack`-- Performs the initialization for the Parallel Computing  Toolbox Blackjack examples.
    * `pctdemo_task_blackjack` -- Simulates blackjack.
    * `pDemoFigure` -- Returns a handle to a figure that can be used for the Parallel Computing Toolbox demos.
    * `README.md` -- The source file for the readme file you are currently reading.

2) Submit the SLURM job with the following command:

    ```bash
    $ sbatch paralleldemo_parfor_bench.sbatch
    ```
    
    Explanation of command:
    * [`sbatch`](https://slurm.schedmd.com/sbatch.html) - Submit a batch script to Slurm.
    * `paralleldemo_parfor_bench.sbatch` - The SLURM script to submit.
    
3) The progress can be checked in two ways

    Checking the SLURM queue to see the state of the job (e.g. RUNNING, PENDING, etc.)
    
    ```bash
    $ squeue -l -u $USER
    ```

    Viewing the progress from the batch file stdout.
    
    ```bash
    $ tail -f out/sbatch.out
    ```
    
    Explanation of command:
    * [`tail`](http://man7.org/linux/man-pages/man1/tail.1.html) - output the last part of files
    * `-f out/sbatch.out` output appended data as the file `out/sbatch.out` grows
    
    **NOTE** -- this output file will not be created until the SLURM job changes from PENDING to RUNNING.
    
4) View the output files via the [`nano`](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/) or [`vi`](https://www.howtogeek.com/102468/a-beginners-guide-to-editing-text-files-with-vi/) commands, or over SSH with NppFTP

    * `out/sbatch.out` -- stdout file for the SLURM script
    * `out/sbatch.err` -- stderr file for the SLURM script
    * `out/[YYYYMMDD_hhmmss]/` -- log files from MATLAB
    * `/gss_gpfs_scratch/$USER/paralleldemo_parfor_bench/[YYYYMMDD_hhmmss]/` -- Figures output by MATLAB in PNG format
    
    
    
