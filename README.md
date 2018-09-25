NEU_RC_HELLO
============
A collection of demos for the NEU Discovery Cluster. 

Before you begin: become familiar with high-performance computing at Northeastern on the Discover cluster by reading through the [Discovery Cluster Introduction](https://docs.google.com/presentation/d/1aKZzL3o5kf_RVm23YTuOLj1LI2DZFlzitA2g9w6axas/edit?usp=sharing) which covers the following information:
* [Research Computing website](https://its.northeastern.edu/researchcomputing/)
* [Overview](https://its.northeastern.edu/researchcomputing/overview/)
* [Guidelines](https://its.northeastern.edu/researchcomputing/usage-guidelines/).

- [NEU_RC_HELLO](#neu-rc-hello)
- [Preparing to use Discovery](#preparing-to-use-discovery)
- [Interactive nodes](#interactive-nodes)
  * [Starting an interactive node](#starting-an-interactive-node)
  * [Choosing a partition](#choosing-a-partition)
- [Git(hub) on Discovery](#git-hub--on-discovery)
  * [HTTPS](#https)
  * [SSH](#ssh)
- [Internet access and File Transfer](#internet-access-and-file-transfer)
  * [File Transfer](#file-transfer)
    + [rClone](#rclone)
  * [Internet Access from a SLURM job (including interactive nodes)](#internet-access-from-a-slurm-job--including-interactive-nodes-)
- [MATLAB Discovery Cluster](#matlab-discovery-cluster)
- [Python Discovery Cluster](#python-discovery-cluster)

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
    $ srun -n 2 -p general --x11 --pty /bin/bash
    ```
        
    Explanation of command:
    * [`srun`](https://slurm.schedmd.com/srun.html) - Run a slurm job.
    * `-n 2` - Specify that two tasks will be run, so specify at least 2 CPUs. 
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
For security reasons, compute nodes on discovery do not have access to the Internet by default, but you can route web requests through login nodes as follows.

On the node that you'd like to connect to the internet execute the following command:
```bash
export http_proxy="xfer-00.discovery.neu.edu:3128"
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
```

* `export ..._proxy...` -- This sets environment variables with the [proxy settings](https://wiki.archlinux.org/index.php/proxy_settings) so that certain programs (e.g. [wget](https://wiki.archlinux.org/index.php/Wget) and curl) can use the proxy by default. 
* `xfer-00.discovery.neu.edu:3128` -- This specifies the proxy server, which is hosted on the xfer node as a [Squid proxy](https://en.wikipedia.org/wiki/Squid_(software)).
  
Any program that uses the default environment proxy settings will have access to the Internet. (NOTE: This will not work for `ping` ). For example, you can test your proxy with the following command:
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