MATLAB Hello World on Discovery
===============================
This is a MATLAB `parfor` demo running on the NEU Discovery Cluster. This example benchmarks the `parfor` construct by repeatedly playing the card game of blackjack, also known as 21. We use `parfor` to play the card game multiple times in parallel, varying the number of MATLAB® workers, but always using the same number of players and hands. This example is based on the [Simple Benchmarking of PARFOR Using Blackjack](https://www.mathworks.com/help/distcomp/examples/simple-benchmarking-of-parfor-using-blackjack.html) from the MATLAB [Parallel Computing Toolbox Examples](https://www.mathworks.com/help/distcomp/examples.html).

***NOTE*** -- At this time (July 2018) MATLAB can only be run in parallel on a single node, i.e. across the cores of that node. This is due to a misconfigured license for the `discovery_local_r2016a` configuration. Note also that MATLAB Parallel Computing Toolbox only runs across physical cores, *not* logical cores.

- [MATLAB Hello World on Discovery](#matlab-hello-world-on-discovery)
  * [1. Using MATLAB for the first time on Discovery](#1-using-matlab-for-the-first-time-on-discovery)
  * [2. Using an Interactive MATLAB node](#2-using-an-interactive-matlab-node)
  * [3. Running MATLAB in Parallel using `parfor`](#3-running-matlab-in-parallel-using--parfor-)
    + [3a. Configure Matlab to use the cluster](#3a-configure-matlab-to-use-the-cluster)
    + [3b. Create and run a SLURM job.](#3b-create-and-run-a-slurm-job)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

A summary of these commands is available in the [Matlab Discovery Cheat sheet](cheatsheet.md)

1. Using MATLAB for the first time on Discovery
-----------------------------------------------
Before you begin: become familiar with high-performance computing at Northeastern on the Discover cluster by reading through the [Research Computing website](https://www.northeastern.edu/rc/), particularly the [Overview](https://www.northeastern.edu/rc/?page_id=27) and [Guidelines](https://www.northeastern.edu/rc/?page_id=2).

1) Follow the directions to [get an account on Discovery Cluster](https://www.northeastern.edu/rc/?page_id=20)
    * Please CC your professor on all emails to RC.

2) Follow the directions to [connect to Discovery Cluster](https://www.northeastern.edu/rc/?page_id=75)

    * If you are new to all of this and using Windows, I recommend using the following: 
        * [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) Download the full Putty installer.
        * [XMing](https://sourceforge.net/projects/xming/)
        * [Filezilla](https://filezilla-project.org/download.php?type=client)
        * [Notepad++](https://notepad-plus-plus.org/) with the [NppFTP](https://sourceforge.net/projects/nppftp/) plug-in.

        Configure Putty, XMing, and Notepad++ FTP with profiles to easily connect to Discovery.
        
        TODO -- separate this out into its own page and provide instructions for using SSH keys.

3) Getting Matlab to run on Discovery

    * Discovery is not just one computer, but a cluster of many computers. A program called SLURM is used to distribute the compute jobs to the appropriate computer(s) on the cluster. Before we can use Matlab, we need to configure SLURM with the appropriate "modules". Open the file `/home/[YOUR USERNAME]/.bashrc` with [NppFTP](https://sourceforge.net/projects/nppftp/) or via an SSH command window with [`nano`](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/) or [`vi`](https://www.howtogeek.com/102468/a-beginners-guide-to-editing-text-files-with-vi/) and append the following. Explanation of this use of the `.bashrc` file can be found on the [RC software page](https://www.northeastern.edu/rc/?page_id=16) and the [Matlab job description page](https://www.northeastern.edu/rc/?page_id=18#matjobs).

        ```bash
        # User specific aliases and functions
        #####################################
        
        # Prerequisites for Matlab
        module load gnu-4.4-compilers
        module load fftw-3.3.3
        module load platform-mpi
        module load oracle_java_1.7u40
        module load perl-5.20.0
        module load slurm-14.11.8
        
        module load matlab_mdcs_2016a
        ```
				
2. Using an Interactive MATLAB node
-----------------------------------
Create an interactive node for Matlab. 
The [RC Guidelines](https://www.northeastern.edu/rc/?page_id=2) tell us that we cannot run Matlab on the *log-in nodes* (i.e. discovery2 and discovery4). So, we need to use SLURM  to create a job. The easiest way to do this is to create an [*interactive job*](https://www.northeastern.edu/rc/?page_id=18#intjobs). 

1) Use Putty to SSH into a Discovery login node.

2) Use the SLURM `salloc` command to allocate one `ser-par-10g-4` compute node for exclusive use. 

    *NOTE* -- We could choose any of the [partitions on the discovery cluster](https://www.northeastern.edu/rc/?page_id=14), but only some partitions have the libraries for Matlab GUI. If you receive an error about `error: /usr/lib64/libGL`, select another partition or [contact research computing](https://www.northeastern.edu/rc/?page_id=24). Alternatively, you can use the following command to start Matlab below `$ matlab -softwareopengl`.
    
    ```bash
    $ salloc -N 1 --exclusive -p ser-par-10g-4
    ```
        
    Explanation of command:
    * [`salloc`](https://slurm.schedmd.com/salloc.html) - Obtain a Slurm job allocation (a set of nodes), execute a command, and then release the allocation when the command is finished.
    * `-N 1` - Request at least 1 node.
    * `--exclusive` - The job allocation can not share nodes with other running jobs.
    * `-p ser-par-10g-4` - Select one of the nodes on the `ser-par-10g-4` partition. See [list of partitions](https://www.northeastern.edu/rc/?page_id=14).
    
    
    You should receive the following response with a unique identifier 

    ```bash
    salloc: Granted job allocation 14018745
    ```

3) In order to connect to the node that you just allocated, you need to know which of the `ser-par-10g-4` nodes was allocated to you. You can use the SLURM `squeue` command to see the node that is running and allocated to you.

    ```bash
    $ squeue -l -u $USER
    ```
    
    Explanation of command:
    * [`squeue`](https://slurm.schedmd.com/squeue.html) - view information about jobs located in the Slurm scheduling queue.
    * `-l` - Report more of the available information for the selected jobs or job steps, subject to any constraints specified.
    * `-u $USER` - Only return the jobs of the current user. Note: `$USER` is a Unix environment variable that returns the current user's username. 
    
    You should receive the following response. The JOBID should match the number from the previous step. The `compute-0-208` node was allocated in this case. 
    
    ```bash
    Mon Apr 30 13:30:58 2018
         JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
      14018745 ser-par-1     bash   mbkane  RUNNING      14:04 1-00:00:00      1 compute-0-208
    ```

4) Now, connect to the node via SSH. Use the `-X` flag to enable the [X11 window system](https://en.wikipedia.org/wiki/X_Window_System) that allows us to see the standard Matlab GUI. In this case, the node name was `compute-0-208`, but yours will likely be different. 

    If you are Windows, make sure to start XMing before running the following command. You should see the XMing Windows tray icon. Otherwise, Matlab will open in command line only mode within the SSH window. 
    
    | XMing Windows tray icon |
    |:-----------------------:|
    | ![XMing tray icon](https://www.cs.iastate.edu/files/page/images/x-forwarding-win08.png) |
    
    ```bash
    $ ssh -X [NODE NAME FROM ABOVE]
    ```
    
    Explanation of command:
    * [`ssh`](https://www.ssh.com/ssh/command/#sec-SSH-Command-in-Linux) - The ssh command provides a secure encrypted connection between two hosts over an insecure network. This connection can also be used for terminal access, file transfers, and for tunneling other applications. Graphical X11 applications can also be run securely over SSH from a remote location.
    * `-X` - Enables X11 forwarding.
    * `[NODE NAME FROM ABOVE]` - The host name to connect to, e.g. `compute-0-208`
    
    Note how the command line prompt changed from 
    
    ```bash
    [[YOUR USERNAME]@discovery[2 OR 4] ~]$
    ```
    
    to
    
    ```bash
    [[YOUR USERNAME]@[NODE NAME] ~]$
    ```
    
    You will find this command prefix helps to determine what machine you are currently typing commands into.

3. Running MATLAB in Parallel using `parfor`
--------------------------------------------

### 3a. Configure Matlab to use the correct nodes on the cluster.

1) Run Matlab. Make sure that you have XMing running on your local machine. You should see the XMing icon in your system tray.

    ```bash
    $ matlab
    ```
            
    Matlab should now be running through X11 on your computer.
    
2) [Configure Matlab](https://www.northeastern.edu/rc/?page_id=18#matjobs) to run in parallel mode using the `ser-par-10g-4` partitioned nodes on the cluster. 

    * Configure MATLAB to run parallel jobs on your cluster by calling configCluster.

        ```matlab
        > configCluster
        ```
        
    * Check `ClusterInfo.getQueueName` is empty.

    * Then set it to the partition you wish Matlab to launch jobs on.

        ```matlab
        > ClusterInfo.setQueueName(‘[NAME OF SLURM PARTITION]’)
        ```
        
        For example
        
        ```matlab
        > ClusterInfo.setQueueName(‘ser-par-10g-4’)
        ```
        
    * Check `ClusterInfo.getQueueName` is empty.
    
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
    
    
    