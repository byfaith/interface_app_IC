%% Set of data get from normal-hearing

clear all
clc

% Wiener
% wienerData1 = [0 0 .28 .33 0 0; 0 .25 .43 0 0 0; 0 0 0 0 0 .4; 0 0 0 0 0 0];
% wienerData2 = [.28 0 .57 .67 0 0; 0 0 0 0 .4 0; .25 0 0 .4 0 .167; 0 0 0 0 0 0];
% wienerData3 = [1 .33 0 0 .5 .33; 1 0 0 0 0 .33; .14 0 .167 0 0 .14; 0 0 0 0 0 0];
% wienerData4 = [.5 0 1 .125 .43 .43; 0 .43 0 .375 .14 .57; 1 0 .4 0 0 .14; .28 0 0 0 0 0];  

% Wiener - new
wienerData1 = [.2 1 .8 .5 .28; .4 0 0 0 .25; .143 .2 0 .5 0; 0 0 0 0 0]; % - OK
wienerData2 = [0 0.25 0 0 0.11; .43 .33 .67 0 .167; 0 0 0 .25 0; .4 0 0 0 0]; % - OK
wienerData3 = [0 0.167 .25 .2 0; 0.2 1 0 0.1 0; 0.375 0.43 0 0 0.143; 0.85 0.5 0 0 0];  % - OK
wienerData4 = [.285 .33 0 0 .143; .167 0 0 0 0; .167 .143 0 .125 0; 0 0 0 0 0];  

% MMSE
% mmseData1 = [.125 .78 .28 0 .28 0; .6 0 .6 .43 .875 0; .1 .25 .28 0 .14 0; .28 .14 0 .25 .167 .167];
% mmseData2 = [0 .8 1 .167 .71 .71; .55 0 .57 1 .375 .375; 0 .43 .71 0 0 0; 0 .71 0 0 .28 .75];
% mmseData3 = [1 0 0 .85 0 1; .167 .33 0 .125 0 .71; .167 0 .71 0 0 0; 0 .43 0 0 1 .167];
% mmseData4 = [.5 .67 0 .28 1 .6; 0 .5 .71 .167 1 0; .86 .57 0 .5 .375 .125; 1 0 0 0 0 .83]; 

% MMSE - new
mmseData1 = [.375 .6 .28 .167 0; .4 .125 .83 0 .667; 0 .5 0 .28 .125; 0 0 0 0 0]; % - OK
mmseData2 = [1 .83 .18 .43 .1; .143 .667 .143 0 1; 0 .43 0 0 .2; .125 0 0 0 .57]; % - OK
mmseData3 = [.57 0.28 0.33 0 0.625; 0 .143 0 .667 .8; .11 0 0 0 0; 0.28 .4 0.75 0 .143];  % - OK
mmseData4 = [1 .85 .143 1 .5; 0 .8 0 0 0; 0 .2 .285 0 .5; .2 0 .4 0 0]; 

% Binary Mask
% bmskData1 = [0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
% bmskData2 = [.6 0 0 0 0 0; 0 .5 0 0 .43 .125; 0 0 0 0 0 0; 0 0 0 0 0 0];
% bmskData3 = [.14 .57 .4 1 1 .4; 0 0 0 0 0 0; 0 0 0 0 0 .14; 0 0 0 0 0 0];
% bmskData4 = [0 .167 .28 .43 .43 .28; 0 0 .33 0 0 .28; 0 0 .167 0 .28 0; 0 0 0 0 0 0];  

% BMSK - new
bmskData1 = [0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0]; % - OK
bmskData2 = [.143 .4 .5 .33 0; .375 0 0 0 .143; 0 0 0 0 0; 0 0 0 0 0]; % - OK
bmskData3 = [.125 .28 .125 0 0; 0 0 0 0 0; 0 0 0 0 0;0 0 0 0 0];  % - OK
bmskData4 = [.167 0 0 0 0; 0 0 0 0 0; 0 0 0 .125 0; 0 0 0 0 0];  

% Unproc
% unData1 = [ 0 0 0 0 0 0; .8 0 0 0 0 0;  0 0 0 0 0 0; 0 0 0 0 0 0];
% unData2 = [0 .43 .43 0 0 .6; .8 0 0 0 0 .6; 0 0 0 0 0 0; 0 0 0 0 0 0];
% unData3 = [0 0 0 0 1 .167; 0 0 .28 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
% unData4 = [.3 0 0 .3 0 0; 0 .2 0 0 0 0; 0 0 0 0 .125 0; 0 0 0 .167 0 0];   

% Unproc - New
unData1 = [ 0 0 0 0 0; 0 0 0 0 0;  0 0 0 0 0; 0 0 0 0 0]; % - OK
unData2 = [0 0 0 0 0; 0 .167 0 0 0; 0 .167 0 0 0; 0 0 0 0 0]; % - OK
unData3 = [0.143 0.33 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0];  % - OK
unData4 = [0 0 .167 .375 .25; 0 .2 0 0 0; 0 0 0 0 0; 0 0 0 0 0];   

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
pos1 = [0 2.1 4.5 7.1];
pos2 = [.4 2.4 4.9 7.4];
pos3 = [.8 2.7 5.3 7.7];
pos4 = [1.2 3 5.7 8];
figure;
h1 = boxplot([mmseData(4,:)' mmseData(3,:)' mmseData(2,:)' ...
    mmseData(1,:)'], [0 2.5 5 7.5]', 'positions', pos1',...
    'colors', 'b','width',0.2);
hold on

h2 = boxplot([wienerData(4,:)' wienerData(3,:)' wienerData(2,:)' ...
    wienerData(1,:)'], [0 2.5 5 7.5]', 'positions', pos2',...
    'colors', 'r','width',0.2);

h3 = boxplot([bmskData(4,:)' bmskData(3,:)' bmskData(2,:)' ...
    bmskData(1,:)'], [0 2.5 5 7.5]', 'positions', pos3',...
    'colors', 'k','width',0.2);

h4 = boxplot([unData(4,:)' unData(3,:)' unData(2,:)' ...
    unData(1,:)'], [0 2.5 5 7.5]', 'positions', pos4',...
    'colors', 'm','width',0.2);

axis([-1 9 -10 100])
legend([h1(5,1),h2(5,1),h3(5,1),h4(5,1)], {'MMSE','Wiener',...
    'Máscara Binária','Não-processado'})
xlabel('SNR[dB]')
ylabel('Taxa de Reconheimento de Palavras[%]')

set(gca,'FontSize',22);
h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
print(gcf, '-dpdf', strcat('TaxaRecNormo'));

