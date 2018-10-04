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
$ matlab
```

Common Flags
------------
* `-nodisplay` - Use this if you do not want to use the Matlab GUI and just want to run the Matlab command line in the shell.

[Go to top](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)

Parallelization
---------------
NOTE -- At this time (July 2018) MATLAB can only be run in parallel on a single node, i.e. across the physical (not logical) cores of that node. If you need to run jobs on multiple nodes, you may submit a request to ITS for Matlab MDCS license.

Verify this Cluster configuration using the default local profile.

```matlab
> parpool('local')
```

From here, you should be able to run your Matlab code that utilizes [parfor](https://www.mathworks.com/help/distcomp/parfor.html), parallelized across all the cores of the compute node. **NOTE** Discovery does not support parallelization across multiple nodes at this time.

SLURM Scripts
=============
TODO
