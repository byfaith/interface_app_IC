%% Set of data get from normal-hearing

clear all
clc

% Wiener
wienerData1 = [0 .25 .43 0 0 0; 0 0 0 0 0 0];
wienerData2 = [0 0 0 0 .4 0; 0 0 0 0 0 0];
wienerData3 = [1 0 0 0 0 .33; 0 0 0 0 0 0];
wienerData4 = [.167 0 .2 .25 .67 .6; .28 0 0 0 0 0];

% MMSE
mmseData1 = [.6 0 .6 .43 .875 0; .28 .14 0 .25 .167 .167];
mmseData2 = [.55 0 .57 1 .375 .375; 0 .71 0 0 .28 .75];
mmseData3 = [.167 .33 0 .125 0 .71; 0 .43 0 0 1 .167];
mmseData4 = [.28 .667 0 0 0 1; 0 0 1 .4 0 .167];

% Binary Mask
bmskData1 = [0 0 0 0 0 0; 0 0 0 0 0 0];
bmskData2 = [0 .5 0 0 .43 .125; 0 0 0 0 0 0];
bmskData3 = [0 0 0 0 0 0; 0 0 0 0 0 0];
bmskData4 = [0 0 0 0 0 0; 0 0 0 0 0 0];

% Unproc
unData1 = [.8 0 0 0 0 0; 0 0 0 0 0 0];
unData2 = [.8 0 0 0 0 .6; 0 0 0 0 0 0];
unData3 = [0 0 .28 0 0 0; 0 0 0 0 0 0];
unData4 = [0 0 0 0 0 0; 0 0 0 0 0 0];

% wienerData = [wienerData1 wienerData2 wienerData3 wienerData4];
wienerData = [mean(wienerData1,2) mean(wienerData2,2) ...
    mean(wienerData3,2) mean(wienerData4,2)];

mmseData = [mean(mmseData1,2) mean(mmseData2,2) ...
    mean(mmseData3,2) mean(mmseData4,2)];

bmskData = [mean(bmskData1,2) mean(bmskData2,2) ...
    mean(bmskData3,2) mean(bmskData4,2)];

unData = [mean(unData1,2) mean(unData2,2) ...
    mean(unData3,2) mean(unData4,2)];

%% plots
% plot boxplot of all algoriths, in terms of SNR(0dB and 5dB)
figure;boxplot(