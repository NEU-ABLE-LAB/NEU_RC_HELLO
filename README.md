NEU_RC_HELLO
============
A collection of demos for the NEU Discovery Cluster. 

Before you begin: become familiar with high-performance computing at Northeastern on the Discover cluster by reading through the [Discovery Cluster Introduction](https://docs.google.com/presentation/d/1aKZzL3o5kf_RVm23YTuOLj1LI2DZFlzitA2g9w6axas/edit?usp=sharing) which covers the following information:
* [Research Computing website](https://its.northeastern.edu/researchcomputing/)
* [Overview](https://its.northeastern.edu/researchcomputing/overview/)
* [Guidelines](https://its.northeastern.edu/researchcomputing/usage-guidelines/).

TOC
====

- [NEU_RC_HELLO](#neu-rc-hello)
- [TOC](#toc)
- [Preparing to use Discovery](#preparing-to-use-discovery)
- [Interactive nodes](#interactive-nodes)
  * [Starting an interactive node](#starting-an-interactive-node)
  * [Choosing a partition](#choosing-a-partition)
- [Git(hub) on Discovery](#git-hub--on-discovery)
  * [HTTPS](#https)
  * [SSH](#ssh)
- [Internet access and File Transfer](#internet-access-and-file-transfer)
  * [Initiating File Transfers *to* Discovery](#initiating-file-transfers--to--discovery)
  * [Initiating File Transfers (and internet access) *from* Discovery](#initiating-file-transfers--and-internet-access---from--discovery)
    + [rClone](#rclone)
- [MATLAB Discovery Cluster](#matlab-discovery-cluster)
- [Python Discovery Cluster](#python-discovery-cluster)
- [Other Resources](#other-resources)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

[Go to top](#neu-rc-hello)

Preparing to use Discovery
==========================
**TODO** - Explain setting up Putty, Notepad++ & NppFTP, FileZilla, XMing, Keepass, Pagent, KeeAgent.

Interactive nodes
=================
Interactive nodes are used for small jobs and prototyping code for larger jobs. **Do not run even simple programs just after logging in**; instead, create an interactive node.

Starting an interactive node
----------------------------

1) SSH into a Discovery login node. (For example, using Putty.)

2) Use the SLURM [`srun`](https://slurm.schedmd.com/srun.html) command to allocate an interactive SLUR job. 
    
    If you are Windows, make sure to start XMing before running the following command. You should see the XMing Windows tray icon. Otherwise, software that uses a graphical interface may not open properly (e.g. Matlab). 
    
    | XMing Windows tray icon |
    |:-----------------------:|
    | ![XMing tray icon](https://www.cs.iastate.edu/files/page/images/x-forwarding-win08.png) |
    
    ```bash
    $ srun -n 2 --mem=4gb -p general --x11 --pty /bin/bash
    ```
        
    Explanation of command:
    * [`srun`](https://slurm.schedmd.com/srun.html) - Run a slurm job.
    * `-n 2` - Specify that two tasks will be run, so specify at least 2 CPU cores. 
    * `--mem=4gb` - Specify that a minimum of 4GB of memory should be allocated to the job.
    * `-p general` - Request nodes from the `general` partition.
    * `--x11` - Enable graphical interfaces to be forwared through the SSH connection using the [X Window System](https://en.wikipedia.org/wiki/X_Window_System).
    * `--pty /bin/bash` After provisioning the job, start a pseudo terminal and then open the standard [Bash Unix shell](https://en.wikipedia.org/wiki/Bash_(Unix_shell)). 
    
    If you requested resources that aren't immediately available, you'll enter into a queue. 
    
    ```bash
    srun: job 647429 queued and waiting for resources
    ```
    
        Where `647429` will be a unique ID for the job. If you don't want to wait and can provision fewer resources, you can kill the request by typing <kbd>ctrl</kbd>+<kbd>c</kdb>, and try again.
    
    Once the requested resources are available, you'll enter into a new shell provisioned for the job. 
    
    ```bash
    [mbkane@c0114 ~]$
    ```
    
        Where `mbkane` will be your username, and `c0114` will be node that has been provisioned for your job.
        
    Information about your jobs can be obtained from `squeue`:
    
    ```bash
    squeue -l -u $USER -o "%.18i %.9P %.2t %.10M %.6D %.4C %.10m %.6z %N"
    ```
    
    which returns the following information:
    
    * `JOBID` - Job or job step id. In the case of job arrays, the job ID format will be of the form "<base_job_id>_<index>". By default, the job array index field size will be limited to 64 bytes. Use the environment variable SLURM_BITSTR_LEN to specify larger field sizes. (Valid for jobs and job steps) In the case of heterogeneous job allocations, the job ID format will be of the form "#+#" where the first number is the "heterogeneous job leader" and the second number the zero origin offset for each component of the job.
    * `PARTITION` - Partition of the job or job step. (Valid for jobs and job steps)
    * `ST` - Job state in compact form. See the JOB STATE CODES section below for a list of possible states. (Valid for jobs only)
    * `TIME` - Time used by the job or job step in days-hours:minutes:seconds. The days and hours are printed only as needed. For job steps this field shows the elapsed time since execution began and thus will be inaccurate for job steps which have been suspended. Clock skew between nodes in the cluster will cause the time to be inaccurate. If the time is obviously wrong (e.g. negative), it displays as "INVALID". (Valid for jobs and job steps)
    * `NODES` - Number of nodes allocated to the job or the minimum number of nodes required by a pending job. The actual number of nodes allocated to a pending job may exceed this number if the job specified a node range count (e.g. minimum and maximum node counts) or the job specifies a processor count instead of a node count and the cluster contains nodes with varying processor counts. As a job is completing this number will reflect the current number of nodes allocated. (Valid for jobs only)
    * `CPUS` - Number of CPUs (processors) requested by the job or allocated to it if already running. As a job is completing this number will reflect the current number of CPUs allocated. (Valid for jobs only)
    * `MIN_MEMORY` - Minimum size of memory (in MB) requested by the job. (Valid for jobs only)
    * `S:C:T` - Number of requested sockets, cores, and threads (S:C:T) per node for the job. When (S:C:T) has not been set, "*" is displayed. (Valid for jobs only)
    * `NODELIST` - List of nodes allocated to the job or job step. In the case of a COMPLETING job, the list of nodes will comprise only those nodes that have not yet been returned to service. (Valid for jobs and job steps)
    
    You can get information about the node(s) you're using with the following command
    
    ```bash
    scontrol show node <node name>
    ```
        
3)  Now any commands that you execute in this window will execute on the machine core(s) in the cluster allocated by SLURM.

[Go to top](#neu-rc-hello)

Choosing a partition
--------------------

Some partitions may be used more often than others, making it difficult to get a node assigned for your job. Use the following [`sinfo`](https://slurm.schedmd.com/sinfo.html) commands to determine the status of nodes on the discovery cluster.

* `sinfo` -- Status of all nodes
* `sinfo -p <partition>` -- Status of all nodes on the partition `<partition>`. E.g. `sinfo -p ser-par-10g-4`
* `sinfo -t idle` -- List all idle nodes. 

Some partitions may be listed by the `sinfo` command which are not available for you. See [Discovery Partitions](https://www.northeastern.edu/rc/?page_id=14) for full details on installed and available partitions. 

[Go to top](#neu-rc-hello)

Git(hub) on Discovery
=====================
Git software is available on all Discovery notes. However, since only the login nodes have access to the Internet you can only push/pull to a remote repo on the login nodes (e.g. `login.discovery.neu.edu`) and the xfer nodes (e.g. `xfer-00.discovery.neu.edu`).

HTTPS
-----
Github prefers that you use HTTPS when connecting to Github repositories. Git will prompt you for your Github username and password. Your username is simply your Github username. However, for your password, you will have to [create a personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) if your account is protected by [two-factor authentication](https://help.github.com/articles/securing-your-account-with-two-factor-authentication-2fa/) (TFA). (*Which it should be!*). This token should only be used on the discovery cluster and will be used in lieu of your password since the command line doesn't support TFA.

SSH
----
**TODO** - Explain setting up SSH keys. Reinforce that SSH keys should be password protected.

[Go to top](#neu-rc-hello)

Internet access and File Transfer
=================================

Initiating File Transfers *to* Discovery
--------------------------------------
When using FTP, rsync, filezill, winscp, etc. to  transfer data to/from Discovery, use `xfer-00.discovery.neu.edu` instead of `login.discovery.neu.edu`. This xfer node is dedicated to data transfer, alleviating this load from the login nodes. 

Initiating File Transfers (and internet access) *from* Discovery
--------------------------------------------------------------
For security reasons, compute nodes on discovery do not have direct access to the Internet. They do however indiectly access the internet through a automatically established proxy connection into the xfer nodes (e.g. `xfer-00.discovery.neu.edu`). 

You can confirm the proxy settings were automatically loaded by running the following command that will show the proxy settings (e.g. `http_proxy` and `https_proxy`). 

```bash
env | grep proxy
```

*NOTE*: If a proxy service you need is not automatically established (e.g. ftp) you may have to establish the setting yourself.
  
Any program that uses the default environment proxy settings will have access to the Internet. (*NOTE*: This will not work for `ping` ). For example, you can test your proxy with the following command:
```bash
curl http://example.com
```

### rClone
[Rclone](https://rclone.org/) is a command line program to sync files and directories to and from cloud storage. 

The rclone module must be loaded before use. You may wish to add this line to your `.bashrc` file so that rclone is available every time you log in.
```bash
module load rclone
```

Reference the [rclone documentation](https://rclone.org/docs/) for setting up file transfers between Discovery and your favorite cloud storage. We at NEU get *unlimited* storage space on Google drive; however the transfer speeds can be unpredictable and slow. See [this detailed analysis](http://moo.nac.uci.edu/~hjm/HOWTO-rclone-to-Gdrive.html) of GD transfer speeds and best practices.

[Go to top](#neu-rc-hello)

MATLAB Discovery Cluster
========================

 * [Hello World example](matlab/README.md)
 * [Matlab Discovery Cheat sheet](matlab/cheatsheet.md)
 
[Go to top](#neu-rc-hello)

Python Discovery Cluster
========================
***TODO***

[Go to top](#neu-rc-hello)

Other Resources
===============

* [Official SLURM documentation](https://slurm.schedmd.com/)
* [Official SLURM cheat sheet](https://slurm.schedmd.com/pdfs/summary.pdf)
* [Convenient SLURM Commands (Harvard)](https://www.rc.fas.harvard.edu/resources/documentation/convenient-slurm-commands/)

[Go to top](#neu-rc-hello)
