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
wienerData = 100.*[mean(wienerData1,2) mean(wienerData2,2) ...
    mean(wienerData3,2) mean(wienerData4,2)];

% mmseData = [mmseData1 mmseData2 mmseData3 mmseData4];
mmseData = 100.*[mean(mmseData1,2) mean(mmseData2,2) ...
    mean(mmseData3,2) mean(mmseData4,2)];

% bmskData = [bmskData1 bmskData2 bmskData3 bmskData4];
bmskData = 100.*[mean(bmskData1,2) mean(bmskData2,2) ...
    mean(bmskData3,2) mean(bmskData4,2)];

% unData = [unData1 unData2 unData3 unData4];
unData = 100.*[mean(unData1,2) mean(unData2,2) ...
    mean(unData3,2) mean(unData4,2)];

%% plots
% plot boxplot of all algoriths, in terms of SNR(0dB and 5dB)
% % FIX THE RANGE/SPACE OF THE GRAPHS
pos1 = [0 4.5];
pos2 = [.4 4.9];
pos3 = [.8 5.3];
pos4 = [1.2 5.7];
figure;
h1 = boxplot([mmseData(2,:)' mmseData(1,:)'], [0 5]', 'positions', pos1',...
    'colors', 'b','width',0.2);
hold on

h2 = boxplot([wienerData(2,:)' wienerData(1,:)'], [0 5]', 'positions', pos2',...
    'colors', 'r','width',0.2);

h3 = boxplot([bmskData(2,:)' bmskData(1,:)'], [0 5]', 'positions', pos3',...
    'colors', 'k','width',0.2);

h4 = boxplot([unData(2,:)' unData(1,:)'], [0 5]', 'positions', pos4',...
    'colors', 'm','width',0.2);

axis([-1 7 -10 50])
legend([h1(5,1),h2(5,1),h3(5,1),h4(5,1)], {'MMSE','Wiener',...
    'Binary Mask','Unprocessed'})
xlabel('[dB]')
ylabel('WCR[%]')
