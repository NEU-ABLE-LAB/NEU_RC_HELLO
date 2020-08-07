%% parpoolBenchmarkClusterWorkers
% Reference:
% https://www.mathworks.com/help/parallel-computing/examples/benchmark-your-cluster-workers.html
% =========================================================================

% Vary the number of tasks in a job, and have each task perform a fixed
% amount of work (called weak scaling), we usually scale up to the cluster to solve
% larger problems. Speedup based on weak scaling is also known
% as scaled speedup.

% Start Parallel pool
if isempty(gcp('nocreate')) == 1
    parpool('Discovery',4)
end
tClient = bench;
f = parfevalOnAll(@bench,1);
tWorkers = fetchOutputs(f);
tClientAndWorkers = [tClient;tWorkers];
ax = axes;
bar(tClientAndWorkers');
ax.XTickLabel = ["LU","FFT","ODE","Sparse"];
xlabel("Benchmark type");
ylabel("Benchmark execution time (seconds)");
workerNames = strcat("Worker ",string(1:size(tWorkers,1)));
legend(["Client",workerNames]);