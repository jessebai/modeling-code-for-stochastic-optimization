load('error.mat');
load('outdata.mat');
percentage=network1_errors{1}./outdata;
Max=max(percentage);
Mean=mean(percentage);
Median=median(percentage);
Var=var(percentage);