% Get SRT50 
clear all
close all
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

% Get WRC x SNR
[wrcMMSE_order, index_wrcMMSE] = sort(wrcMMSE);
snr_orderMMSE = sort(snr(index_wrcMMSE));

% Get average values
[snrMMSE_values, wrcAvrgValuesMMSE, dataBoxMMSE] = wrcAvrg(snr_orderMMSE, wrcMMSE_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrMMSE_values)); % No weighting

[~, curveMMSE, ~] = ...
    FitPsycheCurveLogit(snrMMSE_values, wrcAvrgValuesMMSE, weights, targets);

figure;plot(snr,'-.')
hold on
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

% Get WRC x SNR
[wrcWiener_order, index_wrcWiener] = sort(wrcWiener);
snr_orderWiener = sort(snr(index_wrcWiener));

% Get average values
[snrWiener_values, wrcAvrgValuesWiener, dataBoxWiener] = wrcAvrg(snr_orderWiener, wrcWiener_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrWiener_values)); % No weighting

[~, curveWiener, ~] = ...
    FitPsycheCurveLogit(snrWiener_values, wrcAvrgValuesWiener, weights, targets);

hold on;plot(snr,'-')
hold on
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

% Get WRC x SNR
[wrcBMsk_order, index_wrcBMsk] = sort(wrcBMsk);
snr_orderBMsk = sort(snr(index_wrcBMsk));

% Get average values
[snrBMsk_values, wrcAvrgValuesBMsk, dataBoxBMsk] = wrcAvrg(snr_orderBMsk, wrcBMsk_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrBMsk_values)); % No weighting

[~, curveBMsk, ~] = ...
    FitPsycheCurveLogit(snrBMsk_values, wrcAvrgValuesBMsk, weights, targets);

plot(snr,'--')
hold on
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

% Get average values
[snrUn_values, wrcAvrgValues, dataBoxUn] = wrcAvrg(snr_orderUn, wrcUn_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrUn_values)); % No weighting

[~, curveUn, ~] = ...
    FitPsycheCurveLogit(snrUn_values, wrcAvrgValues, weights, targets);

plot(snr)
hold on
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])
h = legend('MMSE', 'Wiener', 'Máscara Binária', 'Não-processado');
set(h);


%% Plot WRC x SNR, per each strategy. Then approximates by logit curve

% scatter graph about one algorithm
figure;scatter(snr_orderUn, 100.*wrcUn_order,'*r')
hold on;
scatter(snr_orderMMSE, 100.*wrcMMSE_order,'b')
scatter(snr_orderWiener, 100.*wrcWiener_order,'k')
scatter(snr_orderBMsk, 100.*wrcBMsk_order,'c')

% Try to represent in Boxplot format
% figure;
% boxplot(100.*wrcUn_order, snr_orderUn)
% hold on
% boxplot(100.*wrcMMSE_order, snr_orderMMSE)
% boxplot(100.*wrcWiener_order, snr_orderWiener)
% boxplot(100.*wrcBMsk_order, snr_orderBMsk)


% logit approximation relation to average values, per algorithm, for one p.
% figure;
plot(curveUn(:,1), 100.*curveUn(:,2),'-r')
hold on
plot(curveMMSE(:,1), 100.*curveMMSE(:,2), '-.b')
plot(curveWiener(:,1), 100.*curveWiener(:,2), '-.k')
plot(curveBMsk(:,1), 100.*curveBMsk(:,2), 'c')
h = legend('Não-processado', 'MMSE', 'Wiener', 'Máscara Binária');
set(h);
xlabel('SNR[dB]')
ylabel('WRC[%]')

% Find a way to represent all the data collected (all participants)
% Then represent graphically

