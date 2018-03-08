% Get SRT50 
clear all
clc
%% MMSE
addpath('Data\CIusers\Marina')
load('Marina_MMSE.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

figure;plot(snr)
hold on
title('MMSE')
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])
%% Wiener
addpath('Data\CIusers\Marina')
load('Marina_Wiener.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

figure;plot(snr)
hold on
title('Wiener')
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])

%% Binary Mask
addpath('Data\CIusers\Marina')
load('Marina_Binary.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

figure;plot(snr)
hold on
title('Binary Mask')
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])
%% Unproc
addpath('Data\CIusers\Marina')
load('Marina_Un.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
wrc = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

figure;plot(snr)
hold on
title('Unprocessed')
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])