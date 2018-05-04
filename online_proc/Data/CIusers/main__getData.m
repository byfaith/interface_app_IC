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
% Get WRC x SNR
wrcMMSE = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

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
% Get WRC x SNR
wrcWiener = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

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
% Get WRC x SNR
wrcBMsk = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

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
% Get WRC x SNR
wrcUn = resultados.numAcertos(index)./resultados.numTotalPalavras(index);
[wrcUn_order, index_wrcUn] = sort(wrcUn);
snr_orderUn = sort(snr(index_wrcUn));
% figure;scatter(snr_order, wrc_order)
% Now, approximate to logit function

plot(snr)
hold on
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])
h = legend('MMSE', 'Wiener', 'M�scara Bin�ria', 'N�o-processado');
set(h);


%% Plot WRC x SNR, per each strategy. Then approximates by logit curve

% Organize data - NOW GET VALUES FROM EACH SNR, THEN OBTAIN AVERAGE VALUE
for k=1:length(snr_orderUn)
    if k==1
        a(k) = snr_orderUn(k);
    elseif k~=1 && (snr_orderUn(k)~=snr_orderUn(k-1))
        a(k) = snr_orderUn(k);
    end
end
snrUn_values = a(a~=0);

% scatter(snr_orderUn, wrcUn_order)
[ffit, curve] = FitPsycheCurveWH(snr_orderUn, wrcUn_order, 0);
% plot(curve)


