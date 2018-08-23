%%init.m
% function to initialize path and adapt to ML version
% run this before start testing

% loads online/* directories to path
home = strcat(pwd,filesep); %current directory
addpath(genpath(strcat(home,'online_proc',filesep)));

% check matlab version
mv = version;
mv = str2double(mv(1:3));

if mv < 9.1
   addpath(strcat(home,'ML_version_comp',filesep));
end
cd('online_proc')
clearvars;