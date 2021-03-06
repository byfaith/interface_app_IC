% Get SRT50 
clear all
close all
clc
%% MMSE
% addpath('Data\CIusers\Marina')
% addpath('Marina')
% load('Marina_MMSE.mat')

% addpath('Data\CIusers\Marina')
% addpath('Data\CIusers\Marina2')
% load('Marina_MMSE.mat')

% index1 = find(resultados.numTotalPalavras); 
% snr1 = resultados.snr_vecValues(index1);
% 
% % Get WRC x SNR
% wrcMMSE1 = resultados.numAcertos(index1)./resultados.numTotalPalavras(index1);
% 
% [wrcMMSE_order1, index_wrcMMSE1] = sort(wrcMMSE1);
% snr_orderMMSE1 = sort(snr1(index_wrcMMSE1));
% % Data from subject 1
% scatter(snr_orderMMSE1, wrcMMSE_order1)
% -------------

% addpath('Data\CIusers\Rosana')
% addpath('Rosana')
% load('Ro_MMSE.mat')


addpath('Data\CIusers\Adelaide')
addpath('Adelaide')
load('MMSE.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
% 
% Get WRC x SNR
wrcMMSE = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

% Get WRC x SNR
[wrcMMSE_order, index_wrcMMSE] = sort(wrcMMSE);
snr_orderMMSE = sort(snr(index_wrcMMSE));
% 
% % Data from subject 2
% hold on; figure;scatter(snr_orderMMSE, wrcMMSE_order,'r')
% % --------- Try: concatenate variables
% [wrcMMSE_orderF, index_wrcMMSEF] = sort([wrcMMSE; wrcMMSE1]);
% snrF = [snr; snr1];
% snr_orderMMSEF = sort(snrF(index_wrcMMSEF));
% 
% % ERROR IN FUNCTION: 'wrcAvrg.m': FIX IT!
% [snrMMSE_valuesF, wrcAvrgValuesMMSEF, dataBoxMMSEF] = ...
%     wrcAvrg(snr_orderMMSEF, wrcMMSE_orderF);
% % Send SNR and WRC average values - Read about this model!
% targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
% weights = ones(1,length(snrMMSE_valuesF)); % No weighting
% 
% [~, curveMMSEF, ~] = ...
%     FitPsycheCurveLogit(snrMMSE_valuesF, wrcAvrgValuesMMSEF, weights, targets);
% 
% % figure;scatter(snr_orderMMSEF, 100.*wrcMMSE_orderF,'*r')
% % ---------

% Get average values
[snrMMSE_values, wrcAvrgValuesMMSE, dataBoxMMSE] = wrcAvrg(snr_orderMMSE, wrcMMSE_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrMMSE_values)); % No weighting

[~, curveMMSE, ~] = ...
    FitPsycheCurveLogit(snrMMSE_values, wrcAvrgValuesMMSE, weights, targets);


% figure;scatter(snrMMSE_values, 100.*wrcAvrgValuesMMSE,'*r')

figure;plot(snr,'-.')
hold on
% axis([0 35 -10 25 ])
%% Wiener
% addpath('Data\CIusers\Marina')
% addpath('Data\CIusers\Marina2')
% load('Marina_Wiener.mat')
% addpath('Data\CIusers\Rosana')
% load('Ro_Wiener.mat')
addpath('Data\CIusers\Adelaide')
addpath('Adelaide')
load('W.mat')

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
% axis([0 35 -10 25 ])

%% Binary Mask
% addpath('Data\CIusers\Marina2')
% addpath('Data\CIusers\Marina')
% load('Marina_Binary.mat')
% addpath('Data\CIusers\Rosana')
% load('Ro_BMsk.mat')
addpath('Data\CIusers\Adelaide')
addpath('Adelaide')
load('BM.mat')


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
% axis([0 35 -10 25 ])
%% Unproc
% addpath('Data\CIusers\Marina2')
% addpath('Data\CIusers\Marina')
% load('Marina_Un.mat')
% addpath('Data\CIusers\Rosana')
% load('Ro_Un.mat')
addpath('Data\CIusers\Adelaide')
addpath('Adelaide')
load('UN.mat')


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

[coeffs, curveUn, threshold] = ...
    FitPsycheCurveLogit(snrUn_values, wrcAvrgValues, weights, targets);


plot(snr)
hold on
xlabel('N�mero de Senten�as')
ylabel('SNR [dB]')
% axis([0 35 -10 25 ])
h = legend('MMSE', 'Wiener', 'M�scara Bin�ria', 'N�o-processado');
set(h);
set(gca,'FontSize',22);
h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS3','norm'));


%% Plot WRC x SNR, per each strategy. Then approximates by logit curve

% scatter graph about one algorithm
figure;scatter(snr_orderUn, 100.*wrcUn_order,'*r')
hold on;
scatter(snr_orderMMSE, 100.*wrcMMSE_order,'b')
scatter(snr_orderWiener, 100.*wrcWiener_order,'*k')
scatter(snr_orderBMsk, 100.*wrcBMsk_order,'m')

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
plot(curveMMSE(:,1), 100.*curveMMSE(:,2), '-b')
plot(curveWiener(:,1), 100.*curveWiener(:,2), '-k')
plot(curveBMsk(:,1), 100.*curveBMsk(:,2), '-m')
h = legend('N�o-processado', 'MMSE', 'Wiener', 'M�scara Bin�ria');
set(h);
xlabel('SNR[dB]')
ylabel('Taxa de Reconhecimento de Palavras[%]')

% Get SRT50 index, for each algorithm
SRTUnpos = find(round(100*curveUn(:,2))==50);
SRT50Un = curveUn(SRTUnpos(1,1),1);
SRTMMSEpos = find(round(100*curveMMSE(:,2))==50);
SRT50MMSE = curveMMSE(SRTMMSEpos(1,1),1);
SRTWienerpos = find(round(100*curveWiener(:,2))==50);
SRT50Wiener = curveWiener(SRTWienerpos(1,1),1);
SRTBMskpos = find(round(100*curveBMsk(:,2))==50);
SRT50BMsk = curveBMsk(SRTBMskpos(1,1),1);

% Draw line
xlineUn = [50.*ones(SRTUnpos(1,1),1)];
h(3)=plot(curveUn(1:SRTUnpos,1),xlineUn,'-.k');
h(5) = plot([SRT50Un SRT50Un],[0 50],'-.k');
xlineMMSE = [50.*ones(SRTMMSEpos(1,1),1)];
h(3)=plot(curveMMSE(1:SRTMMSEpos,1),xlineMMSE,'-.k');
h(5) = plot([SRT50MMSE SRT50MMSE],[0 50],'-.k');
xlineWiener = [50.*ones(SRTWienerpos(1,1),1)];
h(3)=plot(curveWiener(1:SRTWienerpos,1),xlineWiener,'-.k');
h(5) = plot([SRT50Wiener SRT50Wiener],[0 50],'-.k');
xlineBMsk = [50.*ones(SRTBMskpos(1,1),1)];
h(3)=plot(curveBMsk(1:SRTBMskpos,1),xlineBMsk,'-.k');
h(5) = plot([SRT50BMsk SRT50BMsk],[0 50],'-.k');

% Insert legend
h(4) = plot(SRT50Un,50,'rx','DisplayName',['SRT50_{NP} = ' num2str(SRT50Un)]);
h(6) = plot(SRT50MMSE,50,'bx','DisplayName',['SRT50_{MMSE} = ' num2str(SRT50MMSE)]);
h(7) = plot(SRT50Wiener,50,'kx','DisplayName',['SRT50_{Wiener} = ' num2str(SRT50Wiener)]);
h(8) = plot(SRT50BMsk,50,'mx','DisplayName',['SRT50_{MB} = ' num2str(SRT50BMsk)]);
legend([h(4) h(6) h(7) h(8)],'location','southeast')

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS3'));


% Find a way to represent all the data collected (all participants)
% Then represent graphically

%% Represent error between reference approximate curve (unproc)
size(curveUn)
size(curveMMSE)
size(curveWiener)
size(curveBMsk)

% Resample set of data based on higher vector
% a = resample(curveUn(:,1), length(curveBMsk), length(curveUn));
curveBMskR = resample(curveBMsk(:,2), length(curveMMSE), length(curveBMsk));
curveWienerR = resample(curveWiener(:,2), length(curveMMSE), length(curveWiener));
curveUnR = resample(curveUn(:,2), length(curveMMSE), length(curveUn));

% HERE: obtain boxplot now, for all subjects!
% But first: organize code!
errBMskUn   = curveUnR - curveBMskR;
errWienerUn  = curveUnR - curveWienerR;
errMMSEUn = curveUnR - curveMMSE(:,2);
