Cheat sheet for using Matlab on the Discovery Cluster
====================================================

See the [MATLAB Hello World on Discovery example](README.md) for more complete details and usage examples.

General [Discovery Cheat Sheet](https://github.com/NEU-ABLE-LAB/NEU_RC_HELLO/blob/master/README.md)

- [Cheat sheet for using Matlab on the Discovery Cluster](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)
- [Starting Matlab](#starting-matlab)
- [SLURM Scripts](#slurm-scripts)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

[Go to top](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)

Starting Matlab
===============
Start an [interactive node](https://github.com/NEU-ABLE-LAB/NEU_RC_HELLO/blob/master/README.md#starting-an-interactive-node) before starting Matlab.

```bash
$ matlab -softwareopengl
```

Only some [Discovery partitions](https://www.northeastern.edu/rc/?page_id=14) have the libraries for Matlab GUI. If you receive an error about `error: /usr/lib64/libGL`, select another partition or contact research computing. Alternatively, you can use the following command to start `Matlab below $ matlab -softwareopengl`

[Go to top](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)

SLURM Scripts
=============
TODO
