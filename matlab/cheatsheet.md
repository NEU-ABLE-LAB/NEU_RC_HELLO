Cheat sheet for using Matlab on the Discovery Cluster
====================================================

See the [MATLAB Hello World on Discovery example](readme.md) for more complete details and usage examples.

Interactive nodes
-----------------

### Starting an interactive node
```bash
$ salloc -N 1 --exclusive -p [PARTITION_NAME]
$ squeue -l -u $USER
$ ssh -X [NODE_NAME]
$ matlab
```
where:
* `PARTITION_NAME` is one of the [discovery partitions](https://www.northeastern.edu/rc/?page_id=14)
  - `ser-par-10g-4` recommended for general purpose use
* `NODE_NAME` is the node name assigned by `salloc` returned by the `squeue` command
  

SLURM Scripts
-------------
TODO
  
Internet access
---------------
Compute nodes on discovery do not have access to the Internet by default, but you can route web requests through login nodes as follows.

### Web Access on Interactive nodes
On the login node:
```bash
$ ssh -R 2200:localhost:22 $USER@[NODE_NAME] ssh -D 10800 -p 2200 localhost
```
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

### Web Access in SLURM Scripts
TODO
  