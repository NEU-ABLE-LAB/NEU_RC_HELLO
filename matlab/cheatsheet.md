Cheat sheet for using Matlab on the Discovery Cluster
====================================================

See the [MATLAB Hello World on Discovery example](README.md) for more complete details and usage examples.

General [Discovery Cheat Sheet](https://github.com/NEU-ABLE-LAB/NEU_RC_HELLO/blob/master/README.md)

TOC
====

- [Cheat sheet for using Matlab on the Discovery Cluster](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)
- [TOC](#toc)
- [Starting Matlab](#starting-matlab)
  * [Common Flags](#common-flags)
- [Parallelization](#parallelization)
  * [Create a Parallel Pool](#create-a-parallel-pool)
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
* `-nodisplay` - Use this if you do not want to use the Matlab GUI (through X11) and just want to run the Matlab command line in the shell.

Matlab GUI
----------
*X11* is used to send the Matlab GUI to your local computer. Make sure an X11 server is running on your computer (e.g. [XMing](https://sourceforge.net/projects/xming/)), you didn't specify the `-nodisplay` flag above, and your created the interactive node with the `--X11` flag. 

*Keyboard shortcuts* - If you find that <kbd>CTRL</kbd>+<kbd>C</kbd> or other shortcuts don't work, check the Matlab key bindings as described [here](https://www.mathworks.com/matlabcentral/answers/103161-why-am-i-unable-to-use-copy-ctrl-c-and-paste-ctrl-v-keyboard-short-cuts-in-the-text-editing-mode#answer_112506).

[Go to top](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)

Parallelization
===============
**NOTE** -- At this time (October 2018) MATLAB can only be run in parallel on a single node, i.e. across the physical (not logical) cores of that node. *Therefore*, you should only create SLURM jobs (e.g. with `srun` or `sbatch`) with a single node. This can be guaranteed by setting the nodes flag to a minimum and maximum of one node `--nodes=1-1`. 

Create a Parallel Pool
----------------------

```matlab
parpool(<NumWorkers>)
```

where `<NumWorkers>` is the integrer number of parallel workers Matlab should use with the following constraints
* `<NumWorkers>` ≤ The value returned by the Matlab command `getfield(parcluster(parallel.defaultClusterProfile),'NumWorkers')` - I.e., the number maximum number of workers allowed by the current Matlab cluster configuration, in the case the default cluster configuration.
    
    * To increase this limit, up to the `<numcpus>` limit below, run the following Matlab command [H/T](https://www.mathworks.com/help/distcomp/saveprofile.html):
    
      ```matlab
      myCluster = parcluster(parallel.defaultClusterProfile); % Create a cluster object
      myCluster.NumWorkers = <numcpus>; % Change the maximum number of workers
      saveProfile(myCluster); % Save the changes to the cluster profile
      disp(myCluster); % Confirm change
      ```
      
      TODO - Programmatically set this limit.
    
* `<NumWorkers>` ≤ The value returned by the shell command `squeue -O numcpus -j <JobID>`, where `<JobID>` is the ID of the SLURM job running the Matlab instance of interest. This Assumes SLURM only provisioned one node, i.e. `squeue -O numnodes -j <JobID>` is 1. 

  * To increase this limit, restart the SLURM job (e.g. with `srun` or `sbatch`) with a larger value of `-n` upto the maximum available on the partition used.

[Go to top](#cheat-sheet-for-using-matlab-on-the-discovery-cluster)

SLURM Scripts
=============
TODO
