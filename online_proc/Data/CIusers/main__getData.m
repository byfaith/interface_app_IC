% Get SRT50 
clear all
clc
%% MMSE
% addpath('Data\CIusers\Marina')
% addpath('Marina')
% load('Marina_MMSE.mat')

addpath('Data\CIusers\Rosana')
addpath('Rosana')
load('Ro_MMSE.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

figure;plot(snr,'-.')
hold on
% title('MMSE')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])
%% Wiener
% addpath('Data\CIusers\Marina')
% load('Marina_Wiener.mat')
addpath('Data\CIusers\Rosana')
load('Ro_Wiener.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

hold on;plot(snr,'-')
hold on
% title('Wiener')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])

%% Binary Mask
% addpath('Data\CIusers\Marina')
% load('Marina_Binary.mat')
addpath('Data\CIusers\Rosana')
load('Ro_BMsk.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

plot(snr,'--')
hold on
% title('Binary Mask')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])
%% Unproc
% addpath('Data\CIusers\Marina')
% load('Marina_Un.mat')
addpath('Data\CIusers\Rosana')
load('Ro_Un.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

% find a way to represent SNR x WRC. Then, represent curve and approximate
% to logit function
% Solution:
[wrc_order, index_wrc] = sort(wrc);
snr_order = sort(snr(index_wrc));
figure;scatter(snr_order, wrc_order)
% Now, approximate to logit function

plot(snr)
hold on
% title('Unprocessed')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])
h = legend('MMSE', 'Wiener', 'Máscara Binária', 'Não-processado');
set(h);