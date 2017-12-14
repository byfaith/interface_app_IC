% Plot psychometric function
%%
clc
clear all
close all

% Load results in '.mat' format
% load('resultadoTrial.mat')

% Call function 'FitPsycheCurveWH.m'
% This parameters are redefine in function of intelligibilit curve
SPs = [0.35, 0.1, 10, 10; % Upper limits for g, l, u ,v
    0.01, 0.05, 5, 1; % Start points for g, l, u ,v
    0, 0, -5, 0]; % Lower limits for  g, l, u ,v

[coeffs, curve] = FitPsycheCurveWH(x, app.acertoPercentualUp, SPs);

%% graph
figure;scatter(x,100.*app.acertoPercentualUp)
hold on
plot(curve(:,1),100.*curve(:,2),'LineStyle','--')
xlabel('SNR')
ylabel('Acertos(%)')
