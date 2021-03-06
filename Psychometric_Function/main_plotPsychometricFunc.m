% Plot psychometric function
%%
clc
clear all
%close all

% Load results in '.mat' format
load('TestFilipe_1.mat')

% Spli into up and down results
SNR = [-20 -8 -6 -4 -2 0 2 4 6 8 10 12 30];
acertosUp = resultados.numAcertos(1:13)./resultados.numTotalPalavras(1:13);
acertosDw = resultados.numAcertos(14:end)./resultados.numTotalPalavras(14:end);
acertosDw = fliplr(acertosDw');
acertosMn = (acertosDw'+acertosUp)./2;
% 
% % Call function 'FitPsycheCurveWH.m'
% % This parameters are redefine in function of intelligibilit curve
% SPs = [0.50, 0.05, inf, inf; % Upper limits for g, l, u ,v
%     0.01, 0.01, 5, 1; % Start points for g, l, u ,v
%     0, 0, 0, 0]; % Lower limits for  g, l, u ,v
% 
% [coeffs, curve] = FitPsycheCurveWH(SNR, acertosMn, SPs); % Try to fit without fitting toolbox

% https://www.mathworks.com/matlabcentral/answers/126146-curve-fitting-without-the-toolbox
% available toolboxes:
% MATLAB                                                Version 9.1         (R2016b)
% Simulink                                              Version 8.8         (R2016b)
% Control System Toolbox                                Version 10.1        (R2016b)
% DSP System Toolbox                                    Version 9.3         (R2016b)
% Data Acquisition Toolbox                              Version 3.10        (R2016b)
% Image Processing Toolbox                              Version 9.5         (R2016b)
% Instrument Control Toolbox                            Version 3.10        (R2016b)
% Optimization Toolbox                                  Version 7.5         (R2016b)
% Regularization Tools                                  Version 4.1                 
% Signal Processing Toolbox                             Version 7.3         (R2016b)
% Simulink Control Design                               Version 4.4         (R2016b)
% Statistics and Machine Learning Toolbox               Version 11.0        (R2016b)
% Symbolic Math Toolbox                                 Version 7.1         (R2016b)


%% Using FitPsycheCurveLogit.m
% Fit psychometirc functions - STUDY ABOUT!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(SNR)); % No weighting

[~, curve, ~] = ...
    FitPsycheCurveLogit(SNR', acertosMn, weights, targets);

%% graph
figure;
h(1)=scatter(SNR,100.*acertosMn);
hold on
h(2)=plot(curve(:,1),100.*curve(:,2));%,'LineStyle','--')
xlabel('SNR')
ylabel('Acertos(%)')

% Intert indication of SRT50 and plot curves..
SRTpos = find(round(100*curve(:,2))==50);
SRT50 = curve(SRTpos(1,1),1);

% Draw line
xline = [50.*ones(SRTpos(1,1),1)];% zeros(size(curve,1)-SRTpos(1,1),1)];
h(3)=plot(curve(1:SRTpos,1),xline,'--k');
h(5) = plot([SRT50 SRT50],[0 50],'--k');
% Insert legend
h(4) = plot(SRT50,50,'kx','DisplayName',['SRT50 = ' num2str(SRT50)]);

legend(h(4),'location','southeast')

% h = legend(['SRT50 = ' num2str(SRT50)]);
% set(h);

