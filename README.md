NEU_RC_TEST
===========
A collection of demos for the NEU Discovery Cluster. 

Before you begin: become familiar with high-performance computing at Northeastern on the Discover cluster by reading through the [Research Computing website](https://www.northeastern.edu/rc/), particularly the [Overview](https://www.northeastern.edu/rc/?page_id=27) and [Guidelines](https://www.northeastern.edu/rc/?page_id=2).

- [NEU_RC_TEST](#neu-rc-test)
- [MATLAB Discovery Cluster](#matlab-discovery-cluster)
- [Python Discovery Cluster](#python-discovery-cluster)
- [Interactive nodes](#interactive-nodes)
  * [Starting an interactive node](#starting-an-interactive-node)
- [Git(hub) on Discovery](#git-hub--on-discovery)
  * [SSH](#ssh)
  * [HTTPS](#https)
- [Internet access](#internet-access)
  * [Web Access on Interactive nodes](#web-access-on-interactive-nodes)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

[Go to top](#neu-rc-test)

MATLAB Discovery Cluster
========================

 * [Hello World example](matlab/README.md)
 * [Matlab Discovery Cheat sheet](matlab/cheatsheet.md)
 
[Go to top](#neu-rc-test)

Python Discovery Cluster
========================
***TODO***

[Go to top](#neu-rc-test)

Interactive nodes
=================

Starting an interactive node
----------------------------
```bash
$ salloc -N 1 --exclusive -p [PARTITION_NAME]
$ squeue -l -u $USER
$ ssh -X -C [NODE_NAME]
```
where:
* `PARTITION_NAME` is one of the [discovery partitions](https://www.northeastern.edu/rc/?page_id=14)
  - `ser-par-10g-4` recommended for general purpose use
* `NODE_NAME` is the node name assigned by `salloc` returned by the `squeue` command

[Go to top](#neu-rc-test)

Git(hub) on Discovery
=====================
To use a new(er) version of Git, add the following to your `.bashrc` file

```bash
# Git Module
#   Without this, only Git 1.7.1 is available only
#   the login nodes, and no Git is available on the
#   compute nodes. With this module, this version of
#   Git is available throughout.
module load git-2.9.5
```

Then log out and log back in. (Alternitively, run this module load command directly from the command line for it to work immediately in the current session, but not persist.)

To test the Git version, type the following

```bash
git --version
```

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
