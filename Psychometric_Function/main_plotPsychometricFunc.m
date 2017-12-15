% Plot psychometric function
%%
clc
clear all
close all

% Load results in '.mat' format
load('TestBMsk_Gustavo_1.mat')

% Spli into up and down results
SNR = [-20 -8 -6 -4 -2 0 2 4 6 8 10 12 30];
acertosUp = resultados.numAcertos(1:13)./resultados.numTotalPalavras(1:13);
acertosDw = resultados.numAcertos(14:end)./resultados.numTotalPalavras(14:end);
acertosDw = fliplr(acertosDw');
acertosMn = (acertosDw'+acertosUp)./2;

% Call function 'FitPsycheCurveWH.m'
% This parameters are redefine in function of intelligibilit curve
SPs = [0.35, 0.1, 10, 10; % Upper limits for g, l, u ,v
    0.01, 0.05, 5, 1; % Start points for g, l, u ,v
    0, 0, -5, 0]; % Lower limits for  g, l, u ,v

[coeffs, curve] = FitPsycheCurveWH(SNR, acertosMn, SPs);

%% graph
figure;scatter(SNR,100.*acertosMn)
hold on
plot(curve(:,1),100.*curve(:,2),'LineStyle','--')
xlabel('SNR')
ylabel('Acertos(%)')
