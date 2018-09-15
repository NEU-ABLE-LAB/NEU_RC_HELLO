NEU_RC_TEST
===========
A collection of demos for the NEU Discovery Cluster. 

Before you begin: become familiar with high-performance computing at Northeastern on the Discover cluster by reading through the [Discovery Cluster Introduction](https://docs.google.com/presentation/d/1aKZzL3o5kf_RVm23YTuOLj1LI2DZFlzitA2g9w6axas/edit?usp=sharing) which covers the following information:
* [Research Computing website](https://its.northeastern.edu/researchcomputing/)
* [Overview](https://its.northeastern.edu/researchcomputing/overview/)
* [Guidelines](https://its.northeastern.edu/researchcomputing/usage-guidelines/).

- [NEU_RC_TEST](#neu-rc-test)
- [Interactive nodes](#interactive-nodes)
  * [Starting an interactive node](#starting-an-interactive-node)
- [Git(hub) on Discovery](#git-hub--on-discovery)
  * [SSH](#ssh)
  * [HTTPS](#https)
- [Internet access](#internet-access)
  * [Web Access on Interactive nodes](#web-access-on-interactive-nodes)
- [[MATLAB Discovery Cluster Hello World](matlab/README.md)](#-matlab-discovery-cluster-hello-world--matlab-readmemd-)
- [Python Discovery Cluster Hello World](#python-discovery-cluster-hello-world)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


[Go to top](#neu-rc-test)

Interactive nodes
=================

Starting an interactive node
----------------------------

1) Use Putty to SSH into a Discovery login node.

2) Use the SLURM `srun` command to allocate an interactive SLUR job. 
    
    If you are Windows, make sure to start XMing before running the following command. You should see the XMing Windows tray icon. Otherwise, software that uses a graphical interface may not open properly (e.g. Matlab). 
    
    | XMing Windows tray icon |
    |:-----------------------:|
    | ![XMing tray icon](https://www.cs.iastate.edu/files/page/images/x-forwarding-win08.png) |
    
    ```bash
    $ srun -p general --pty /bin/bash
    ```
        
    Explanation of command:
    * [`srun`](https://slurm.schedmd.com/srun.html) - Run a slurm job.
    * `-p general` - Request nodes from the `general` partition.
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

[Go to top](#neu-rc-test)

Git(hub) on Discovery
=====================
Git is available on all Discovery notes. However, since only the login nodes have access to the Internet, thus you can only push/pull to a remote repo on the login notes.

SSH
---
TODO

HTTPS
-----
The Discovery cluster does not currently fully support accessing repositories over HTTPS, namely it does not yet support credential keyrings.

[Go to top](#neu-rc-test)

Internet access
===============
Compute nodes on discovery do not have access to the Internet by default, but you can route web requests through login nodes as follows.

Web Access on Interactive nodes
-------------------------------
On the login node:
```bash
$ ssh -R 2200:localhost:22 $USER@[NODE_NAME] ssh -D 10800 -p 2200 localhost
```
You may get the response `Pseudo-terminal will not be allocated because stdin is not a terminal.`. In which case, keep that window open, and create another SSH standard session into discovery then into the the interactive node as normal.

* `NODE_NAME` is the node name assigned by `salloc` returned by the `squeue` command
* `-R 2200:localhost:22` sets up a forward from `remote:2200` to `localhost:22`.
* `ssh -p 2200 localhost` runs ssh on remote, to connect to `remote:2200`, and so back to `localhost:22` (tunneled over the first ssh connection).
* `-D 10800` tunnels SOCKS from `remote:10800`, over the connection from remote back to `localhost`.

HT:[ServerFault](https://serverfault.com/questions/624685/making-proxy-available-on-remote-server-through-ssh-tunneling)

Now SSH'd into the interactive node:
```bash
export http_proxy="socks5://localhost:10800"
export https_proxy=$http_proxy
```
Any program that uses the default environment proxy settings will have access to the Internet. (NOTE: This will not work for `ping` or `wget`). For example:
```bash
curl http://google.com

```
[MATLAB Discovery Cluster Hello World](matlab/README.md)
========================================================

 * [Matlab Discovery Cheat sheet](matlab/cheatsheet.md)
 
[Go to top](#neu-rc-test)

Python Discovery Cluster Hello World
====================================
***TODO***

[Go to top](#neu-rc-test)