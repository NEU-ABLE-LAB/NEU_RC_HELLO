Cheat sheet for using Matlab on the Discovery Cluster
====================================================

See the [MATLAB Hello World on Discovery example](readme.md) for more complete details and usage examples.

Interactive node
----------------

### Starting an interactive node
```bash
$ salloc -N 1 --exclusive -p [PARTITION NAME]
$ squeue -l -u $USER
$ ssh -X [NODE NAME FROM ABOVE]
$ matlab
```

Commands: [`salloc`](https://slurm.schedmd.com/salloc.html), [`squeue`](https://slurm.schedmd.com/squeue.html), [`ssh`](https://www.ssh.com/ssh/command/#sec-SSH-Command-in-Linux)
[Partition names](https://www.northeastern.edu/rc/?page_id=14):
  * `ser-par-10g-4` recommended for general purpose use
  
SLURM Scripts
-------------
TODO