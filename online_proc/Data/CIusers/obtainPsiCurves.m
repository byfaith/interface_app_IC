function [curveMMSE, curveUn, curveWiener, curveBMsk] = obtainPsiCurves(path,flagPlot,min_v,max_v)

% min = -20;
% max = 30;


%% MMSE
addpath(path)
load('MMSE.mat')

index = find(resultados.numTotalPalavras);
snr1 = resultados.snr_vecValues(index);

% Get WRC x SNR
wrcMMSE = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

% Get WRC x SNR
[wrcMMSE_order, index_wrcMMSE] = sort(wrcMMSE);
snr_orderMMSE = sort(snr1(index_wrcMMSE));
[snrMMSE_values, wrcAvrgValuesMMSE, dataBoxMMSE] = wrcAvrg(snr_orderMMSE, wrcMMSE_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrMMSE_values)); % No weighting

snrMMSE_values_ = [min_v; snrMMSE_values; max_v];
wrcAvrgValuesMMSE_ = [0; wrcAvrgValuesMMSE; 1];
weights = ones(1,length(snrMMSE_values_)); % No weighting

[~, curveMMSE, ~] = ...
    FitPsycheCurveLogit(snrMMSE_values_, wrcAvrgValuesMMSE_, weights, targets);


%% Un

addpath(path)
load('UN.mat')


index = find(resultados.numTotalPalavras);
snr2 = resultados.snr_vecValues(index);

% Get WRC x SNR
wrcUn = resultados.numAcertos(index)./resultados.numTotalPalavras(index);
[wrcUn_order, index_wrcUn] = sort(wrcUn);
snr_orderUn = sort(snr2(index_wrcUn));

% Get average values
[snrUn_values, wrcAvrgValues, dataBoxUn] = wrcAvrg(snr_orderUn, wrcUn_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrUn_values)); % No weighting

snrUn_values_ = [min_v; snrUn_values; max_v];
wrcAvrgValues_ = [0; wrcAvrgValues; 1];
weights = ones(1,length(snrUn_values_)); % No weighting

[coeffs, curveUn, threshold] = ...
    FitPsycheCurveLogit(snrUn_values_, wrcAvrgValues_, weights, targets);


%% Wiener
addpath(path)
load('W.mat')

index = find(resultados.numTotalPalavras);
snr3 = resultados.snr_vecValues(index);

% Get WRC x SNR
wrcWiener = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

% Get WRC x SNR
[wrcWiener_order, index_wrcWiener] = sort(wrcWiener);
snr_orderWiener = sort(snr3(index_wrcWiener));

% Get average values
[snrWiener_values, wrcAvrgValuesWiener, dataBoxWiener] = wrcAvrg(snr_orderWiener, wrcWiener_order);

% Send SNR and WRC average values - Read about this model!
targets = [0.25, 0.5, 0.75]; % 25%, 50% and 75% performance
weights = ones(1,length(snrWiener_values)); % No weighting

snrWiener_values_ = [min_v; snrWiener_values; max_v];
wrcAvrgValuesWiener_ = [0; wrcAvrgValuesWiener; 1];
weights = ones(1,length(snrWiener_values_)); % No weighting

[~, curveWiener, ~] = ...
    FitPsycheCurveLogit(snrWiener_values_, wrcAvrgValuesWiener_, weights, targets);


%% BMsk
addpath(path)
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

snrBMsk_values_ = [min_v; snrBMsk_values; max_v];
wrcAvrgValuesBMsk_ = [0; wrcAvrgValuesBMsk; 1];
weights = ones(1,length(snrBMsk_values_)); % No weighting

[~, curveBMsk, ~] = ...
    FitPsycheCurveLogit(snrBMsk_values_, wrcAvrgValuesBMsk_, weights, targets);


%% 
% Plot, case flag == 1
if flagPlot == 1
    figure;plot(snr1,'-.k','LineWidth',2)
    hold on

    plot(snr3,'-.b','LineWidth',2)
    hold on

    plot(snr,'-.g','LineWidth',2)
    hold on

    plot(snr2,'r','LineWidth',2)
    hold on
    xlabel('Número de Sentenças')
    ylabel('SNR [dB]')
    % axis([0 35 -10 25 ])
    h = legend('MMSE', 'Wiener', 'Máscara Binária', 'Não-processado');
    set(h);
    set(gca,'FontSize',22);
    h=gcf;
    set(h,'PaperOrientation','landscape');
    set(h,'PaperUnits','normalized');
    set(h,'PaperPosition', [0 0 1 1]);
    % print(gcf, '-dpdf', strcat('twodownS3','norm'));
    
    
    
    figure;scatter(snr_orderUn, 100.*wrcUn_order,'*r')
    hold on;
    scatter(snr_orderMMSE, 100.*wrcMMSE_order,'k')
    scatter(snr_orderWiener, 100.*wrcWiener_order,'*b')
    scatter(snr_orderBMsk, 100.*wrcBMsk_order,'g')

% Try to represent in Boxplot format
% figure;
% boxplot(100.*wrcUn_order, snr_orderUn)
% hold on
% boxplot(100.*wrcMMSE_order, snr_orderMMSE)
% boxplot(100.*wrcWiener_order, snr_orderWiener)
% boxplot(100.*wrcBMsk_order, snr_orderBMsk)


% logit approximation relation to average values, per algorithm, for one p.
% figure;
    plot(curveUn(:,1), 100.*curveUn(:,2),'-r','LineWidth',3)
    hold on
    plot(curveMMSE(:,1), 100.*curveMMSE(:,2), '-k','LineWidth',3)
    plot(curveWiener(:,1), 100.*curveWiener(:,2), '-b','LineWidth',3)
    plot(curveBMsk(:,1), 100.*curveBMsk(:,2), '-g','LineWidth',3)
    h = legend('Não-processado', 'MMSE', 'Wiener', 'Máscara Binária');
    set(h);
    xlabel('SNR[dB]')
    ylabel('Taxa de Reconhecimento de Palavras[%]')

% Get SRT50 index, for each algorithm
    [~,I] = min(abs(100*curveUn(:,2)-50));
    SRT50Un = curveUn(I,1);
    SRTUnpos = I;
%     SRTUnpos = find(round(100*curveUn(:,2))==50);
%     SRT50Un = curveUn(SRTUnpos(1,1),1);
    
    [~,I] = min(abs(100*curveMMSE(:,2)-50));
    SRT50MMSE = curveMMSE(I,1);
    SRTMMSEpos = I;
%     SRTMMSEpos = find(round(100*curveMMSE(:,2))==50);
%     SRT50MMSE = curveMMSE(SRTMMSEpos(1,1),1);
    
    [~,I] = min(abs(100*curveWiener(:,2)-50));
    SRT50Wiener = curveWiener(I,1);
    SRTWienerpos = I;
%     SRTWienerpos = find(round(100*curveWiener(:,2))==50);
%     SRT50Wiener = curveWiener(SRTWienerpos(1,1),1);
    
    [~,I] = min(abs(100*curveBMsk(:,2)-50));
    SRT50BMsk = curveBMsk(I,1);
    SRTBMskpos = I;
%     SRTBMskpos = find(round(100*curveBMsk(:,2))==50);
%     SRT50BMsk = curveBMsk(SRTBMskpos(1,1),1);

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
    h(4) = plot(SRT50Un,50,'rx','DisplayName',['SRT50_{NP} = ' num2str(SRT50Un)],'LineWidth',3,'MarkerSize',10);
    h(6) = plot(SRT50MMSE,50,'kx','DisplayName',['SRT50_{MMSE} = ' num2str(SRT50MMSE)],'LineWidth',3,'MarkerSize',10);
    h(7) = plot(SRT50Wiener,50,'bx','DisplayName',['SRT50_{Wiener} = ' num2str(SRT50Wiener)],'LineWidth',3,'MarkerSize',10);
    h(8) = plot(SRT50BMsk,50,'gx','DisplayName',['SRT50_{MB} = ' num2str(SRT50BMsk)],'LineWidth',3,'MarkerSize',10);
    lgd = legend([h(4) h(6) h(7) h(8)],'location','southeast');
% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS3'));


end

