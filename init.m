%%init.m

% loads online/* directories to path
addpath(genpath(strcat('online_proc',filesep)));

% check matlab version
mv = version;
mv = mv(1:3);

if mv < 9.1
   addpath(strcat('ML_version_comp',filesep));