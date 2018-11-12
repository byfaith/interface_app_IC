
clear all
% Get values from approximated psychometric curve, then calculates relative
% error

rmpath('Adelaide')
rmpath('Rosana')
rmpath('Rosana2')
rmpath('Eliane')
rmpath('P6')
rmpath('Danielle')
[curveMMSE_1, curveUn_1, curveWiener_1, curveBMsk_1] = ...
    obtainPsiCurves('Marina2', 1, -20, 25);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS1'));
% print(gcf, '-dpdf', strcat('logitS1'));


rmpath('Adelaide')
rmpath('Marina2')
rmpath('Rosana2')
rmpath('Eliane')
rmpath('P6')
rmpath('Danielle')
[curveMMSE_2, curveUn_2, curveWiener_2, curveBMsk_2] = ...
    obtainPsiCurves('Rosana', 1, 5, 25);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS2'));
% print(gcf, '-dpdf', strcat('logitS2'));


rmpath('Marina2')
rmpath('Rosana')
rmpath('Rosana2')
rmpath('Eliane')
rmpath('P6')
rmpath('Danielle')
[curveMMSE_3, curveUn_3, curveWiener_3, curveBMsk_3] = ...
    obtainPsiCurves('Adelaide', 1, 0, 25);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS3'));
% print(gcf, '-dpdf', strcat('logitS3'));


rmpath('Marina2')
rmpath('Rosana')
rmpath('Adelaide')
rmpath('Rosana2')
rmpath('Danielle')
[curveMMSE_4, curveUn_4, curveWiener_4, curveBMsk_4] = ...
    obtainPsiCurves('Eliane', 1, 10, 40);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS5'));
% print(gcf, '-dpdf', strcat('logitS5'));


rmpath('Marina2')
rmpath('Rosana')
rmpath('Adelaide')
rmpath('p6')
rmpath('Eliane')
rmpath('Rosana2')
[curveMMSE_5, curveUn_5, curveWiener_5, curveBMsk_5] = ...
    obtainPsiCurves('Danielle', 1, 1, 45);


% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS6'));
% print(gcf, '-dpdf', strcat('logitS6'));



rmpath('Marina2')
rmpath('Rosana')
rmpath('Adelaide')
rmpath('p6')
rmpath('Eliane')
rmpath('Rosana2')
rmpath('Danielle')
[curveMMSE_6, curveUn_6, curveWiener_6, curveBMsk_6] = ...
    obtainPsiCurves('cindia', 1, 5, 40);


% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('twodownS7'));
% print(gcf, '-dpdf', strcat('logitS7'));




% rmpath('Marina2')
% rmpath('Rosana')
% rmpath('Adelaide')
% rmpath('Eliane')
% rmpath('Danielle')
% [curveMMSE_3, curveUn_3, curveWiener_3, curveBMsk_3] = ...
%     obtainPsiCurves('p6', 1, 15, 40);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS4'));





% rmpath('Marina2')
% rmpath('Rosana')
% rmpath('Adelaide')
% rmpath('p6')
% rmpath('l7')
% rmpath('Danielle')
% [curveMMSE_3, curveUn_3, curveWiener_3, curveBMsk_3] = ...
%    obtainPsiCurves('4set18', 1, 10, 40);



% % ANALISAR VARIANCIA SOBRE A PSICOMÉTRICA: SNR=I(0%) - SNR=I(100%) (DÁ
% UMA IDEIA DE QUAL ALGORITMO APRESENTA MENOR DESVIO SOBRE OS RESULTADOS..
% NA VERDADE, MELHOR OBTER O DESVIO PADRÃO!
% fonte: https://link.springer.com/content/pdf/10.3758/BF03211350.pdf


%% Analyse data distribution



%% waste: try to obtain a normalized metric to compare all the data.. fail


% % % % SNR at the intelligibility in 0% and 100% (I0%)
SNR_I_BMsk_0    = curveBMsk_1(find((curveBMsk_1(:,2) > 0.001) & (curveBMsk_1(:,2) < 0.01),1,'last'), 1);
SNR_I_BMsk_100  = curveBMsk_1(find((curveBMsk_1(:,2) < 1.0) & (curveBMsk_1(:,2) > 0.99),1,'first'), 1);

SNR_I_W_0    = curveWiener_1(find((curveWiener_1(:,2) > 0.001) & (curveWiener_1(:,2) < 0.01),1,'last'), 1);
SNR_I_W_100  = curveWiener_1(find((curveWiener_1(:,2) < 1.0) & (curveWiener_1(:,2) > 0.99),1,'first'), 1);

SNR_I_MMSE_0    = curveMMSE_1(find((curveMMSE_1(:,2) > 0.001) & (curveMMSE_1(:,2) < 0.025),1,'last'), 1);
SNR_I_MMSE_100  = curveMMSE_1(find((curveMMSE_1(:,2) < 1.0) & (curveMMSE_1(:,2) > 0.99),1,'first'), 1);

SNR_I_UN_0    = curveUn_1(find((curveUn_1(:,2) > 0.001) & (curveUn_1(:,2) < 0.01),1,'last'), 1);
SNR_I_UN_100  = curveUn_1(find((curveUn_1(:,2) < 1.0) & (curveUn_1(:,2) > 0.99),1,'first'), 1);


% Reorder data, based on the actal thresholds
% S1
curveBMsk_1 = curveBMsk_1(find((curveBMsk_1(:,2) > 0.001) & (curveBMsk_1(:,2) < 0.01),1,'last'):find((curveBMsk_1(:,2) < 1.0) & (curveBMsk_1(:,2) > 0.99),1,'first'),:);
curveWiener_1 = curveWiener_1(find((curveWiener_1(:,2) > 0.001) & (curveWiener_1(:,2) < 0.01),1,'last'):find((curveWiener_1(:,2) < 1.0) & (curveWiener_1(:,2) > 0.99),1,'first'),:);
curveMMSE_1 = curveMMSE_1(find((curveMMSE_1(:,2) > 0.001) & (curveMMSE_1(:,2) < 0.025),1,'last'):find((curveMMSE_1(:,2) < 1.0) & (curveMMSE_1(:,2) > 0.99),1,'first'),:);
curveUn_1 = curveUn_1(find((curveUn_1(:,2) > 0.001) & (curveUn_1(:,2) < 0.01),1,'last'):find((curveUn_1(:,2) < 1.0) & (curveUn_1(:,2) > 0.99),1,'first'),:);

% S2
curveBMsk_2 = curveBMsk_2(find((curveBMsk_2(:,2) > 0.001) & (curveBMsk_2(:,2) < 0.01),1,'last'):find((curveBMsk_2(:,2) < 1.0) & (curveBMsk_2(:,2) > 0.99),1,'first'),:);
curveWiener_2 = curveWiener_2(find((curveWiener_2(:,2) > 0.001) & (curveWiener_2(:,2) < 0.01),1,'last'):find((curveWiener_2(:,2) < 1.0) & (curveWiener_2(:,2) > 0.99),1,'first'),:);
curveMMSE_2 = curveMMSE_2(find((curveMMSE_2(:,2) > 0.001) & (curveMMSE_2(:,2) < 0.025),1,'last'):find((curveMMSE_2(:,2) < 1.0) & (curveMMSE_2(:,2) > 0.99),1,'first'),:);
curveUn_2 = curveUn_2(find((curveUn_2(:,2) > 0.001) & (curveUn_2(:,2) < 0.01),1,'last'):find((curveUn_2(:,2) < 1.0) & (curveUn_2(:,2) > 0.99),1,'first'),:);

% S3
curveBMsk_3 = curveBMsk_3(find((curveBMsk_3(:,2) > 0.001) & (curveBMsk_3(:,2) < 0.01),1,'last'):find((curveBMsk_3(:,2) < 1.0) & (curveBMsk_3(:,2) > 0.99),1,'first'),:);
curveWiener_3 = curveWiener_3(find((curveWiener_3(:,2) > 0.001) & (curveWiener_3(:,2) < 0.01),1,'last'):find((curveWiener_3(:,2) < 1.0) & (curveWiener_3(:,2) > 0.99),1,'first'),:);
curveMMSE_3 = curveMMSE_3(find((curveMMSE_3(:,2) > 0.001) & (curveMMSE_3(:,2) < 0.025),1,'last'):find((curveMMSE_3(:,2) < 1.0) & (curveMMSE_3(:,2) > 0.99),1,'first'),:);
curveUn_3 = curveUn_3(find((curveUn_3(:,2) > 0.001) & (curveUn_3(:,2) < 0.01),1,'last'):find((curveUn_3(:,2) < 1.0) & (curveUn_3(:,2) > 0.99),1,'first'),:);

% S4
curveBMsk_4 = curveBMsk_4(find((curveBMsk_4(:,2) > 0.001) & (curveBMsk_4(:,2) < 0.01),1,'last'):find((curveBMsk_4(:,2) < 1.0) & (curveBMsk_4(:,2) > 0.99),1,'first'),:);
curveWiener_4 = curveWiener_4(find((curveWiener_4(:,2) > 0.001) & (curveWiener_4(:,2) < 0.01),1,'last'):find((curveWiener_4(:,2) < 1.0) & (curveWiener_4(:,2) > 0.99),1,'first'),:);
curveMMSE_4 = curveMMSE_4(find((curveMMSE_4(:,2) > 0.001) & (curveMMSE_4(:,2) < 0.025),1,'last'):find((curveMMSE_4(:,2) < 1.0) & (curveMMSE_4(:,2) > 0.99),1,'first'),:);
curveUn_4 = curveUn_4(find((curveUn_4(:,2) > 0.001) & (curveUn_4(:,2) < 0.01),1,'last'):find((curveUn_4(:,2) < 1.0) & (curveUn_4(:,2) > 0.99),1,'first'),:);

% S5
curveBMsk_5 = curveBMsk_5(find((curveBMsk_5(:,2) > 0.001) & (curveBMsk_5(:,2) < 0.01),1,'last'):find((curveBMsk_5(:,2) < 1.0) & (curveBMsk_5(:,2) > 0.99),1,'first'),:);
curveWiener_5 = curveWiener_5(find((curveWiener_5(:,2) > 0.001) & (curveWiener_5(:,2) < 0.01),1,'last'):find((curveWiener_5(:,2) < 1.0) & (curveWiener_5(:,2) > 0.99),1,'first'),:);
curveMMSE_5 = curveMMSE_5(find((curveMMSE_5(:,2) > 0.001) & (curveMMSE_5(:,2) < 0.025),1,'last'):find((curveMMSE_5(:,2) < 1.0) & (curveMMSE_5(:,2) > 0.99),1,'first'),:);
curveUn_5 = curveUn_5(find((curveUn_5(:,2) > 0.001) & (curveUn_5(:,2) < 0.01),1,'last'):find((curveUn_5(:,2) < 1.0) & (curveUn_5(:,2) > 0.99),1,'first'),:);

% S6
curveBMsk_6 = curveBMsk_6(find((curveBMsk_6(:,2) > 0.001) & (curveBMsk_6(:,2) < 0.01),1,'last'):find((curveBMsk_6(:,2) < 1.0) & (curveBMsk_6(:,2) > 0.99),1,'first'),:);
curveWiener_6 = curveWiener_6(find((curveWiener_6(:,2) > 0.001) & (curveWiener_6(:,2) < 0.01),1,'last'):find((curveWiener_6(:,2) < 1.0) & (curveWiener_6(:,2) > 0.99),1,'first'),:);
curveMMSE_6 = curveMMSE_6(find((curveMMSE_6(:,2) > 0.001) & (curveMMSE_6(:,2) < 0.025),1,'last'):find((curveMMSE_6(:,2) < 1.0) & (curveMMSE_6(:,2) > 0.99),1,'first'),:);
curveUn_6 = curveUn_6(find((curveUn_6(:,2) > 0.001) & (curveUn_6(:,2) < 0.01),1,'last'):find((curveUn_6(:,2) < 1.0) & (curveUn_6(:,2) > 0.99),1,'first'),:);



% Resample set of data based on higher vector
% ALL THE DATA ALL RESAMPLED BASED ON SIZE OF curveMMSE_2 (HIGHER VALUES)
% Error from subject 1
curveBMskR_1    = resample(curveBMsk_1(:,:), length(curveMMSE_1), length(curveBMsk_1));
curveWienerR_1  = resample(curveWiener_1(:,:), length(curveMMSE_1), length(curveWiener_1));
curveUnR_1      = resample(curveUn_1(:,:), length(curveMMSE_1), length(curveUn_1));

errBMskUn_1   = abs(curveBMskR_1(:,1) - curveUnR_1(:,1));
errWienerUn_1  = abs(curveWienerR_1(:,1) - curveUnR_1(:,1));
errMMSEUn_1 = abs(curveMMSE_1(:,1) - curveUnR_1(:,1));


% % Get sum of snr, point per point, considering non-proc as reference
% % as higher the metric (and negative?) less the error
% errBMskUn_1   = sum(curveBMskR_1(1:end-20,1) - curveUnR_1(1:end-20,1));
% errWienerUn_1  = sum(curveWienerR_1(1:end-20,1) - curveUnR_1(1:end-20,1));
% errMMSEUn_1 = sum(curveMMSE_1(1:end-20,1) - curveUnR_1(1:end-20,1));



% % Error from subject 2
curveBMskR_2 = resample(curveBMsk_2(:,:), length(curveMMSE_2), length(curveBMsk_2));
curveWienerR_2 = resample(curveWiener_2(:,:), length(curveMMSE_2), length(curveWiener_2));
curveUnR_2 = resample(curveUn_2(:,:), length(curveMMSE_2), length(curveUn_2));

errBMskUn_2   = abs(curveBMskR_2(:,1) - curveUnR_2(:,1));
errWienerUn_2  = abs(curveWienerR_2(:,1) - curveUnR_2(:,1));
errMMSEUn_2 = abs(curveMMSE_2(:,1) - curveUnR_2(:,1));


% errBMskUn_2   = sum(curveBMskR_2(1:end-10,1) - curveUnR_2(1:end-10,1));
% errWienerUn_2  = sum(curveWienerR_2(1:end-10,1) - curveUnR_2(1:end-10,1));
% errMMSEUn_2 = sum(curveMMSE_2(1:end-10,1) - curveUnR_2(1:end-10,1));


% Error from subject 3
curveBMskR_3 = resample(curveBMsk_3(:,1), length(curveMMSE_3), length(curveBMsk_3));
curveWienerR_3 = resample(curveWiener_3(:,1), length(curveMMSE_3), length(curveWiener_3));
curveUnR_3 = resample(curveUn_3(:,1), length(curveMMSE_3), length(curveUn_3));

errBMskUn_3   = abs(curveBMskR_3(:,1) - curveUnR_3(:,1));
errWienerUn_3  = abs(curveWienerR_3(:,1) - curveUnR_3(:,1));
errMMSEUn_3 = abs(curveMMSE_3(:,1) - curveUnR_3(:,1));

figure;
h1 = boxplot([[errMMSEUn_1; errMMSEUn_2; errMMSEUn_3],...
    [errWienerUn_1; errWienerUn_2; errWienerUn_3],...
    [errBMskUn_1; errBMskUn_2; errBMskUn_3]],...
    'Labels', {'MMSE', 'Wiener', 'Máscara Binária'});

xlabel('Técnicas')
ylabel('Distancia relativa ao sinal não-processado')



% Discriminar por faixa de SNR


%     ------- center of 0SNR for subj. 1
    
    fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)+2.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)-2.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)+2.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)-2.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)+2.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)-2.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)+2.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)-2.5));    

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_0   = (fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1)));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_0  = (fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_0 = (fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    
	[~,I25nU_2] = min(abs(curveUn_2(:,1)+2.5));
    [~,I25pU_2] = min(abs(curveUn_2(:,1)-2.5));
    
    [~,I25nM_2] = min(abs(curveMMSE_2(:,1)+2.5));
    [~,I25pM_2] = min(abs(curveMMSE_2(:,1)-2.5));
    
    [~,I25nB_2] = min(abs(curveBMsk_2(:,1)+100*2.5));
    [~,I25pB_2] = min(abs(curveBMsk_2(:,1)-100*2.5));

    [~,I25nW_2] = min(abs(curveWiener_2(:,1)+100*2.5));
    [~,I25pW_2] = min(abs(curveWiener_2(:,1)-100*2.5)); 
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_0   = (fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_0  = (fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_0 = (fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1)));

	
    [~,I25nU_3] = min(abs(curveUn_3(:,1)+2.5));
    [~,I25pU_3] = min(abs(curveUn_3(:,1)-2.5));
    
    [~,I25nM_3] = min(abs(curveMMSE_3(:,2)+2.5));
    [~,I25pM_3] = min(abs(curveMMSE_3(:,2)-2.5));
    
    [~,I25nB_3] = min(abs(curveBMsk_3(:,2)+2.5));
    [~,I25pB_3] = min(abs(curveBMsk_3(:,2)-2.5));

    [~,I25nW_3] = min(abs(curveWiener_3(:,2)+2.5));
    [~,I25pW_3] = min(abs(curveWiener_3(:,2)-2.5));    
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_0   = (fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_0  = (fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_0 = (fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1)));


    [~,I25nU_4] = min(abs(curveUn_4(:,1)+2.5));
    [~,I25pU_4] = min(abs(curveUn_4(:,1)-2.5));
    
    [~,I25nM_4] = min(abs(curveMMSE_4(:,1)+2.5));
    [~,I25pM_4] = min(abs(curveMMSE_4(:,1)-2.5));
    
    [~,I25nB_4] = min(abs(curveBMsk_4(:,1)+2.5));
    [~,I25pB_4] = min(abs(curveBMsk_4(:,1)-2.5));

    [~,I25nW_4] = min(abs(curveWiener_4(:,1)+2.5));
    [~,I25pW_4] = min(abs(curveWiener_4(:,1)-2.5));    
    
    curveBMskR_4 = resample(curveBMsk_4(I25nB_4:I25pB_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveBMsk_4(I25nB_4:I25pB_4,1)));
    errBMskUn_4_0   = (fact.*(curveBMskR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveWienerR_4 = resample(curveWiener_4(I25nW_4:I25pW_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveWiener_4(I25nW_4:I25pW_4,1)));    
    errWienerUn_4_0  = (fact.*(curveWienerR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveMMSER_4 = resample(curveMMSE_4(I25nM_4:I25pM_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveMMSE_4(I25nM_4:I25pM_4,1)));    
    errMMSEUn_4_0 = (fact.*(curveMMSER_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    
    
    [~,I25nU_5] = min(abs(100*curveUn_5(:,1)+100*2.5));
    [~,I25pU_5] = min(abs(100*curveUn_5(:,1)-100*2.5));
    
    [~,I25nM_5] = min(abs(100*curveMMSE_5(:,1)+100*2.5));
    [~,I25pM_5] = min(abs(100*curveMMSE_5(:,1)-100*2.5));
    
    [~,I25nB_5] = min(abs(100*curveBMsk_5(:,1)+100*2.5));
    [~,I25pB_5] = min(abs(100*curveBMsk_5(:,1)-100*2.5));

    [~,I25nW_5] = min(abs(100*curveWiener_5(:,1)+100*2.5));
    [~,I25pW_5] = min(abs(100*curveWiener_5(:,1)-100*2.5));    
    
    curveBMskR_5 = resample(curveBMsk_5(I25nB_5:I25pB_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveBMsk_5(I25nB_5:I25pB_5,1)));
    errBMskUn_5_0   = (fact.*(curveBMskR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveWienerR_5 = resample(curveWiener_5(I25nW_5:I25pW_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveWiener_5(I25nW_5:I25pW_5,1)));    
    errWienerUn_5_0  = (fact.*(curveWienerR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveMMSER_5 = resample(curveMMSE_5(I25nM_5:I25pM_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveMMSE_5(I25nM_5:I25pM_5,1)));    
    errMMSEUn_5_0 = (fact.*(curveMMSER_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    
    
    
    [~,I25nU_6] = min(abs(100*curveUn_6(:,1)+100*2.5));
    [~,I25pU_6] = min(abs(100*curveUn_6(:,1)-100*2.5));
    
    [~,I25nM_6] = min(abs(100*curveMMSE_6(:,1)+100*2.5));
    [~,I25pM_6] = min(abs(100*curveMMSE_6(:,1)-100*2.5));
    
    [~,I25nB_6] = min(abs(100*curveBMsk_6(:,1)+100*2.5));
    [~,I25pB_6] = min(abs(100*curveBMsk_6(:,1)-100*2.5));

    [~,I25nW_6] = min(abs(100*curveWiener_6(:,1)+100*2.5));
    [~,I25pW_6] = min(abs(100*curveWiener_6(:,1)-100*2.5));    
    
    curveBMskR_6 = resample(curveBMsk_6(I25nB_6:I25pB_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveBMsk_6(I25nB_6:I25pB_6,1)));
    errBMskUn_6_0   = (fact.*(curveBMskR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveWienerR_6 = resample(curveWiener_6(I25nW_6:I25pW_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveWiener_6(I25nW_6:I25pW_6,1)));    
    errWienerUn_6_0  = (fact.*(curveWienerR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveMMSER_6 = resample(curveMMSE_6(I25nM_6:I25pM_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveMMSE_6(I25nM_6:I25pM_6,1)));    
    errMMSEUn_6_0 = (fact.*(curveMMSER_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
%     ------- center of 5 SNR for subj. 1
    
% 	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)-100*2.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)-100*7.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)-100*2.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)-100*7.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)-100*2.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)-100*7.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)-100*2.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)-100*7.5));  

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_5   = (fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1)));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_5  = (fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_5 = (fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)-100*2.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)-100*7.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)-100*2.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)-100*7.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)-100*2.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)-100*7.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)-100*2.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)-100*7.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_5   = (fact.*(curveBMskR_2' - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_5  = (fact.*(curveWienerR_2' - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_5 = (fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1)));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)-100*2.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)-100*7.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)-100*2.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)-100*7.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)-100*2.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)-100*7.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)-100*2.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)-100*7.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_5   = (fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_5  = (fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_5 = (fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    
    
    [~,I25nU_4] = min(abs(100*curveUn_4(:,1)-100*2.5));
    [~,I25pU_4] = min(abs(100*curveUn_4(:,1)-100*7.5));
    
    [~,I25nM_4] = min(abs(100*curveMMSE_4(:,1)-100*2.5));
    [~,I25pM_4] = min(abs(100*curveMMSE_4(:,1)-100*7.5));
    
    [~,I25nB_4] = min(abs(100*curveBMsk_4(:,1)-100*2.5));
    [~,I25pB_4] = min(abs(100*curveBMsk_4(:,1)-100*7.5));

    [~,I25nW_4] = min(abs(100*curveWiener_4(:,1)-100*2.5));
    [~,I25pW_4] = min(abs(100*curveWiener_4(:,1)-100*7.5));
    
    curveBMskR_4 = resample(curveBMsk_4(I25nB_4:I25pB_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveBMsk_4(I25nB_4:I25pB_4,1)));
    errBMskUn_4_5   = (fact.*(curveBMskR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveWienerR_4 = resample(curveWiener_4(I25nW_4:I25pW_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveWiener_4(I25nW_4:I25pW_4,1)));    
    errWienerUn_4_5  = (fact.*(curveWienerR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveMMSER_4 = resample(curveMMSE_4(I25nM_4:I25pM_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveMMSE_4(I25nM_4:I25pM_4,1)));    
    errMMSEUn_4_5 = (fact.*(curveMMSER_4 - curveUn_4(I25nU_4:I25pU_4,1)));

    
    
    [~,I25nU_5] = min(abs(100*curveUn_5(:,1)-100*2.5));
    [~,I25pU_5] = min(abs(100*curveUn_5(:,1)-100*7.5));
    
    [~,I25nM_5] = min(abs(100*curveMMSE_5(:,1)-100*2.5));
    [~,I25pM_5] = min(abs(100*curveMMSE_5(:,1)-100*7.5));
    
    [~,I25nB_5] = min(abs(100*curveBMsk_5(:,1)-100*2.5));
    [~,I25pB_5] = min(abs(100*curveBMsk_5(:,1)-100*7.5));

    [~,I25nW_5] = min(abs(100*curveWiener_5(:,1)-100*2.5));
    [~,I25pW_5] = min(abs(100*curveWiener_5(:,1)-100*7.5));
    
    curveBMskR_5 = resample(curveBMsk_5(I25nB_5:I25pB_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveBMsk_5(I25nB_5:I25pB_5,1)));
    errBMskUn_5_5   = (fact.*(curveBMskR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveWienerR_5 = resample(curveWiener_5(I25nW_5:I25pW_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveWiener_5(I25nW_5:I25pW_5,1)));    
    errWienerUn_5_5  = (fact.*(curveWienerR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
   
    curveMMSER_5 = resample(curveMMSE_5(I25nM_5:I25pM_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveMMSE_5(I25nM_5:I25pM_5,1)));    
    errMMSEUn_5_5 = (fact.*(curveMMSER_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    
    
    [~,I25nU_6] = min(abs(100*curveUn_5(:,1)-100*2.5));
    [~,I25pU_6] = min(abs(100*curveUn_5(:,1)-100*7.5));
    
    [~,I25nM_6] = min(abs(100*curveMMSE_5(:,1)-100*2.5));
    [~,I25pM_6] = min(abs(100*curveMMSE_5(:,1)-100*7.5));
    
    [~,I25nB_6] = min(abs(100*curveBMsk_5(:,1)-100*2.5));
    [~,I25pB_6] = min(abs(100*curveBMsk_5(:,1)-100*7.5));

    [~,I25nW_6] = min(abs(100*curveWiener_5(:,1)-100*2.5));
    [~,I25pW_6] = min(abs(100*curveWiener_5(:,1)-100*7.5));
    
    curveBMskR_6 = resample(curveBMsk_6(I25nB_6:I25pB_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveBMsk_6(I25nB_6:I25pB_6,1)));
    errBMskUn_6_5   = (fact.*(curveBMskR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveWienerR_6 = resample(curveWiener_6(I25nW_6:I25pW_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveWiener_6(I25nW_6:I25pW_6,1)));    
    errWienerUn_6_5  = (fact.*(curveWienerR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
   
    curveMMSER_6 = resample(curveMMSE_6(I25nM_6:I25pM_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveMMSE_6(I25nM_6:I25pM_6,1)));    
    errMMSEUn_6_5 = (fact.*(curveMMSER_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    
%     ------- center of 5 SNR for subj. 1
     
    
    
%     ------- center of -5 SNR for subj. 1
    
% 	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)+7.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)+2.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)+7.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)+2.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)+7.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)+2.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)+7.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)+2.5));    

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_5n   = (fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1)));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_5n  = (fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_5n = (fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)+100*7.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)+100*2.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)+100*7.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)+100*2.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)+100*7.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)+100*2.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)+100*7.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)+100*2.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_5n   = (fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_5n  = (fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_5n = (fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1)));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)+100*7.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)+100*2.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)+100*7.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)+100*2.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)+100*7.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)+100*2.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)+100*7.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)+100*2.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_5n   = (fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_5n  = (fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_5n = (fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1)));

    
    
    [~,I25nU_4] = min(abs(100*curveUn_4(:,1)+100*7.5));
    [~,I25pU_4] = min(abs(100*curveUn_4(:,1)+100*2.5));
    
    [~,I25nM_4] = min(abs(100*curveMMSE_4(:,1)+100*7.5));
    [~,I25pM_4] = min(abs(100*curveMMSE_4(:,1)+100*2.5));
    
    [~,I25nB_4] = min(abs(100*curveBMsk_4(:,1)+100*7.5));
    [~,I25pB_4] = min(abs(100*curveBMsk_4(:,1)+100*2.5));

    [~,I25nW_4] = min(abs(100*curveWiener_4(:,1)+100*7.5));
    [~,I25pW_4] = min(abs(100*curveWiener_4(:,1)+100*2.5));
    
    curveBMskR_4 = resample(curveBMsk_4(I25nB_4:I25pB_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveBMsk_4(I25nB_4:I25pB_4,1)));
    errBMskUn_4_5n   = (fact.*(curveBMskR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveWienerR_4 = resample(curveWiener_4(I25nW_4:I25pW_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveWiener_4(I25nW_4:I25pW_4,1)));    
    errWienerUn_4_5n  = (fact.*(curveWienerR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveMMSER_4 = resample(curveMMSE_4(I25nM_4:I25pM_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveMMSE_4(I25nM_4:I25pM_4,1)));    
    errMMSEUn_4_5n = (fact.*(curveMMSER_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    
    
    [~,I25nU_5] = min(abs(100*curveUn_5(:,1)+100*7.5));
    [~,I25pU_5] = min(abs(100*curveUn_5(:,1)+100*2.5));
   
    [~,I25nM_5] = min(abs(100*curveMMSE_5(:,1)+100*7.5));
    [~,I25pM_5] = min(abs(100*curveMMSE_5(:,1)+100*2.5));
    
    [~,I25nB_5] = min(abs(100*curveBMsk_5(:,1)+100*7.5));
    [~,I25pB_5] = min(abs(100*curveBMsk_5(:,1)+100*2.5));

    [~,I25nW_5] = min(abs(100*curveWiener_5(:,1)+100*7.5));
    [~,I25pW_5] = min(abs(100*curveWiener_5(:,1)+100*2.5));
    
    curveBMskR_5 = resample(curveBMsk_5(I25nB_5:I25pB_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveBMsk_5(I25nB_5:I25pB_5,1)));
    errBMskUn_5_5n   = (fact.*(curveBMskR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveWienerR_5 = resample(curveWiener_5(I25nW_5:I25pW_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveWiener_5(I25nW_5:I25pW_5,1)));    
    errWienerUn_5_5n  = (fact.*(curveWienerR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveMMSER_5 = resample(curveMMSE_5(I25nM_5:I25pM_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveMMSE_5(I25nM_5:I25pM_5,1)));    
    errMMSEUn_5_5n = (fact.*(curveMMSER_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    
    [~,I25nU_6] = min(abs(100*curveUn_6(:,1)+100*7.5));
    [~,I25pU_6] = min(abs(100*curveUn_6(:,1)+100*2.5));
   
    [~,I25nM_6] = min(abs(100*curveMMSE_6(:,1)+100*7.5));
    [~,I25pM_6] = min(abs(100*curveMMSE_6(:,1)+100*2.5));
    
    [~,I25nB_6] = min(abs(100*curveBMsk_6(:,1)+100*7.5));
    [~,I25pB_6] = min(abs(100*curveBMsk_6(:,1)+100*2.5));

    [~,I25nW_6] = min(abs(100*curveWiener_6(:,1)+100*7.5));
    [~,I25pW_6] = min(abs(100*curveWiener_6(:,1)+100*2.5));
    
    curveBMskR_6 = resample(curveBMsk_6(I25nB_6:I25pB_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveBMsk_6(I25nB_6:I25pB_6,1)));
    errBMskUn_6_5n   = (fact.*(curveBMskR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveWienerR_6 = resample(curveWiener_6(I25nW_6:I25pW_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveWiener_6(I25nW_6:I25pW_6,1)));    
    errWienerUn_6_5n  = (fact.*(curveWienerR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveMMSER_6 = resample(curveMMSE_6(I25nM_6:I25pM_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveMMSE_6(I25nM_6:I25pM_6,1)));    
    errMMSEUn_6_5n = (fact.*(curveMMSER_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
%     ------- center of -5 SNR for subj.     
    
    
    
    
% 	------- center of -10 SNR for subj. 1
    
% 	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)+12.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)+7.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)+12.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)+7.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)+12.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)+7.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)+12.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)+7.5));

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_10n   = (fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1)));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_10n  = (fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_10n = (fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1)));
    
    
	[~,I25nU_2] = min(abs(curveUn_2(:,1)+12.5));
    [~,I25pU_2] = min(abs(curveUn_2(:,1)+7.5));
    
    [~,I25nM_2] = min(abs(curveMMSE_2(:,1)+12.5));
    [~,I25pM_2] = min(abs(curveMMSE_2(:,1)+7.5));
    
    [~,I25nB_2] = min(abs(curveBMsk_2(:,1)+12.5));
    [~,I25pB_2] = min(abs(curveBMsk_2(:,1)+7.5));

    [~,I25nW_2] = min(abs(curveWiener_2(:,1)+12.5));
    [~,I25pW_2] = min(abs(curveWiener_2(:,1)+7.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_10n   = (fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_10n  = (fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_10n = (fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1)));

	
    [~,I25nU_3] = min(abs(curveUn_3(:,1)+12.5));
    [~,I25pU_3] = min(abs(curveUn_3(:,1)+7.5));
    
    [~,I25nM_3] = min(abs(curveMMSE_3(:,1)+12.5));
    [~,I25pM_3] = min(abs(curveMMSE_3(:,1)+7.5));
    
    [~,I25nB_3] = min(abs(curveBMsk_3(:,1)+12.5));
    [~,I25pB_3] = min(abs(curveBMsk_3(:,1)+7.5));
    
    [~,I25nW_3] = min(abs(curveWiener_3(:,1)+12.5));
    [~,I25pW_3] = min(abs(curveWiener_3(:,1)+7.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_10n   = (fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_10n  = (fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_10n = (fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1)));

    
    
    [~,I25nU_4] = min(abs(curveUn_4(:,1)+12.5));
    [~,I25pU_4] = min(abs(curveUn_4(:,1)+7.5));
    
    [~,I25nM_4] = min(abs(curveMMSE_4(:,1)+12.5));
    [~,I25pM_4] = min(abs(curveMMSE_4(:,1)+7.5));
    
    [~,I25nB_4] = min(abs(curveBMsk_4(:,1)+12.5));
    [~,I25pB_4] = min(abs(curveBMsk_4(:,1)+7.5));

    [~,I25nW_4] = min(abs(curveWiener_4(:,1)+12.5));
    [~,I25pW_4] = min(abs(curveWiener_4(:,1)+7.5));
    
    curveBMskR_4 = resample(curveBMsk_4(I25nB_4:I25pB_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveBMsk_4(I25nB_4:I25pB_4,1)));
    errBMskUn_4_10n   = (fact.*(curveBMskR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveWienerR_4 = resample(curveWiener_4(I25nW_4:I25pW_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveWiener_4(I25nW_4:I25pW_4,1)));    
    errWienerUn_4_10n  = (fact.*(curveWienerR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveMMSER_4 = resample(curveMMSE_4(I25nM_4:I25pM_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveMMSE_4(I25nM_4:I25pM_4,1)));    
    errMMSEUn_4_10n = (fact.*(curveMMSER_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    
    [~,I25nU_5] = min(abs(curveUn_5(:,1)+12.5));
    [~,I25pU_5] = min(abs(curveUn_5(:,1)+7.5));
    
    [~,I25nM_5] = min(abs(curveMMSE_5(:,1)+12.5));
    [~,I25pM_5] = min(abs(curveMMSE_5(:,1)+7.5));
    
    [~,I25nB_5] = min(abs(curveBMsk_5(:,1)+12.5));
    [~,I25pB_5] = min(abs(curveBMsk_5(:,1)+7.5));

    [~,I25nW_5] = min(abs(curveWiener_5(:,1)+12.5));
    [~,I25pW_5] = min(abs(curveWiener_5(:,1)+7.5));
    
    curveBMskR_5 = resample(curveBMsk_5(I25nB_5:I25pB_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveBMsk_5(I25nB_5:I25pB_5,1)));
    errBMskUn_5_10n   = (fact.*(curveBMskR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveWienerR_5 = resample(curveWiener_5(I25nW_5:I25pW_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveWiener_5(I25nW_5:I25pW_5,1)));    
    errWienerUn_5_10n  = (fact.*(curveWienerR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveMMSER_5 = resample(curveMMSE_5(I25nM_5:I25pM_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveMMSE_5(I25nM_5:I25pM_5,1)));    
    errMMSEUn_5_10n = (fact.*(curveMMSER_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    
    
    
    [~,I25nU_6] = min(abs(curveUn_6(:,1)+12.5));
    [~,I25pU_6] = min(abs(curveUn_6(:,1)+7.5));
    
    [~,I25nM_6] = min(abs(curveMMSE_6(:,1)+12.5));
    [~,I25pM_6] = min(abs(curveMMSE_6(:,1)+7.5));
    
    [~,I25nB_6] = min(abs(curveBMsk_6(:,1)+12.5));
    [~,I25pB_6] = min(abs(curveBMsk_6(:,1)+7.5));

    [~,I25nW_6] = min(abs(curveWiener_6(:,1)+12.5));
    [~,I25pW_6] = min(abs(curveWiener_6(:,1)+7.5));
    
    curveBMskR_6 = resample(curveBMsk_6(I25nB_6:I25pB_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveBMsk_6(I25nB_6:I25pB_6,1)));
    errBMskUn_6_10n   = (fact.*(curveBMskR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveWienerR_6 = resample(curveWiener_6(I25nW_6:I25pW_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveWiener_6(I25nW_6:I25pW_6,1)));    
    errWienerUn_6_10n  = (fact.*(curveWienerR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveMMSER_6 = resample(curveMMSE_6(I25nM_6:I25pM_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveMMSE_6(I25nM_6:I25pM_6,1)));    
    errMMSEUn_6_10n = (fact.*(curveMMSER_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
%     ------- center of -10 SNR for subj. 1
    
    
    
    
%     	------- center of 10 SNR for subj. 1
    
% 	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)-7.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)-12.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)-7.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)-12.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)-7.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)-12.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)-7.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)-12.5));  

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_10p   = (fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1)));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_10p  = (fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1)));
        
	curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_10p = (fact.*(curveMMSER_1' - curveUn_1(I25nU_1:I25pU_1,1)));

    
	[~,I25nU_2] = min(abs(curveUn_2(:,1)-7.5));
    [~,I25pU_2] = min(abs(curveUn_2(:,1)-12.5));
    
    [~,I25nM_2] = min(abs(curveMMSE_2(:,1)-7.5));
    [~,I25pM_2] = min(abs(curveMMSE_2(:,1)-12.5));
    
    [~,I25nB_2] = min(abs(curveBMsk_2(:,1)-7.5));
    [~,I25pB_2] = min(abs(curveBMsk_2(:,1)-12.5));

    [~,I25nW_2] = min(abs(curveWiener_2(:,1)-7.5));
    [~,I25pW_2] = min(abs(curveWiener_2(:,1)-12.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_10p   = (fact.*(curveBMskR_2' - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_10p  = (fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1)));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_10p = (fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1)));

	
    [~,I25nU_3] = min(abs(curveUn_3(:,1)-7.5));
    [~,I25pU_3] = min(abs(curveUn_3(:,1)-12.5));
    
    [~,I25nM_3] = min(abs(curveMMSE_3(:,1)-7.5));
    [~,I25pM_3] = min(abs(curveMMSE_3(:,1)-12.5));
    
    [~,I25nB_3] = min(abs(curveBMsk_3(:,1)-7.5));
    [~,I25pB_3] = min(abs(curveBMsk_3(:,1)-12.5));

    [~,I25nW_3] = min(abs(curveWiener_3(:,1)-7.5));
    [~,I25pW_3] = min(abs(curveWiener_3(:,1)-12.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_10p   = (fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_10p  = (fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1)));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_10p = (fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1)));

    
    
    [~,I25nU_4] = min(abs(curveUn_4(:,1)-7.5));
    [~,I25pU_4] = min(abs(curveUn_4(:,1)-12.5));
    
    [~,I25nM_4] = min(abs(curveMMSE_4(:,1)-7.5));
    [~,I25pM_4] = min(abs(curveMMSE_4(:,1)-12.5));
    
    [~,I25nB_4] = min(abs(curveBMsk_4(:,1)-7.5));
    [~,I25pB_4] = min(abs(curveBMsk_4(:,1)-12.5));

    [~,I25nW_4] = min(abs(curveWiener_4(:,1)-7.5));
    [~,I25pW_4] = min(abs(curveWiener_4(:,1)-12.5));
    
    curveBMskR_4 = resample(curveBMsk_4(I25nB_4:I25pB_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveBMsk_4(I25nB_4:I25pB_4,1)));
    errBMskUn_4_10p   = (fact.*(curveBMskR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveWienerR_4 = resample(curveWiener_4(I25nW_4:I25pW_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveWiener_4(I25nW_4:I25pW_4,1)));    
    errWienerUn_4_10p  = (fact.*(curveWienerR_4 - curveUn_4(I25nU_4:I25pU_4,1)));
    
    curveMMSER_4 = resample(curveMMSE_4(I25nM_4:I25pM_4,1), length(curveUn_4(I25nU_4:I25pU_4,1)), length(curveMMSE_4(I25nM_4:I25pM_4,1)));    
    errMMSEUn_4_10p = (fact.*(curveMMSER_4 - curveUn_4(I25nU_4:I25pU_4,1)));

    
    
    [~,I25nU_5] = min(abs(curveUn_5(:,1)-7.5));
    [~,I25pU_5] = min(abs(curveUn_5(:,1)-12.5));
    
    [~,I25nM_5] = min(abs(curveMMSE_5(:,1)-7.5));
    [~,I25pM_5] = min(abs(curveMMSE_5(:,1)-12.5));
    
    [~,I25nB_5] = min(abs(curveBMsk_5(:,1)-7.5));
    [~,I25pB_5] = min(abs(curveBMsk_5(:,1)-12.5));

    [~,I25nW_5] = min(abs(curveWiener_5(:,1)-7.5));
    [~,I25pW_5] = min(abs(curveWiener_5(:,1)-12.5));
   
    curveBMskR_5 = resample(curveBMsk_5(I25nB_5:I25pB_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveBMsk_5(I25nB_5:I25pB_5,1)));
    errBMskUn_5_10p   = (fact.*(curveBMskR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveWienerR_5 = resample(curveWiener_5(I25nW_5:I25pW_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveWiener_5(I25nW_5:I25pW_5,1)));    
    errWienerUn_5_10p  = (fact.*(curveWienerR_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    curveMMSER_5 = resample(curveMMSE_5(I25nM_5:I25pM_5,1), length(curveUn_5(I25nU_5:I25pU_5,1)), length(curveMMSE_5(I25nM_5:I25pM_5,1)));    
    errMMSEUn_5_10p = (fact.*(curveMMSER_5 - curveUn_5(I25nU_5:I25pU_5,1)));
    
    
    
    
    [~,I25nU_6] = min(abs(curveUn_6(:,1)-7.5));
    [~,I25pU_6] = min(abs(curveUn_6(:,1)-12.5));
    
    [~,I25nM_6] = min(abs(curveMMSE_6(:,1)-7.5));
    [~,I25pM_6] = min(abs(curveMMSE_6(:,1)-12.5));
    
    [~,I25nB_6] = min(abs(curveBMsk_6(:,1)-7.5));
    [~,I25pB_6] = min(abs(curveBMsk_6(:,1)-12.5));

    [~,I25nW_6] = min(abs(curveWiener_6(:,1)-7.5));
    [~,I25pW_6] = min(abs(curveWiener_6(:,1)-12.5));
   
    curveBMskR_6 = resample(curveBMsk_6(I25nB_6:I25pB_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveBMsk_6(I25nB_6:I25pB_6,1)));
    errBMskUn_6_10p   = (fact.*(curveBMskR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveWienerR_6 = resample(curveWiener_6(I25nW_6:I25pW_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveWiener_6(I25nW_6:I25pW_6,1)));    
    errWienerUn_6_10p  = (fact.*(curveWienerR_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
    curveMMSER_6 = resample(curveMMSE_6(I25nM_6:I25pM_6,1), length(curveUn_6(I25nU_6:I25pU_6,1)), length(curveMMSE_6(I25nM_6:I25pM_6,1)));    
    errMMSEUn_6_10p = (fact.*(curveMMSER_6 - curveUn_6(I25nU_6:I25pU_6,1)));
    
%     ------- center of 10 SNR for subj. 1

% 	-- -10dB
%     figure
%     h4 = boxplot([[errBMskUn_1_10n; errBMskUn_2_10n; errBMskUn_3_10n; errBMskUn_4_10n; errBMskUn_5_10n],...
%         [errWienerUn_1_10n; errWienerUn_2_10n; errWienerUn_3_10n; errWienerUn_4_10n; errWienerUn_5_10n],...
%         [errMMSEUn_1_10n; errMMSEUn_2_10n; errMMSEUn_3_10n; errMMSEUn_4_10n; errMMSEUn_5_10n]], 'positions', [0 3 6],...
%         'Labels', {'MB', 'Wiener', 'MMSE'}, 'colors', 'm');    
    
    
%     -- -5dB
%     hold on;
%     h3 = boxplot([[errBMskUn_1_5n; errBMskUn_2_5n; errBMskUn_3_5n; errBMskUn_4_5n; errBMskUn_5_5n],...
%         [errWienerUn_1_5n; errWienerUn_2_5n; errWienerUn_3_5n; errWienerUn_4_5n; errWienerUn_5_5n],...
%         [errMMSEUn_1_5n; errMMSEUn_2_5n; errMMSEUn_3_5n; errMMSEUn_4_5n; errMMSEUn_5_5n]], 'positions', [9 12 15],...
%         'Labels', {'MB', 'Wiener', 'MMSE'}, 'colors', 'g');
    

    
%     -- 0dB
% 	hold on
%     h2 = boxplot([[errBMskUn_1_0; errBMskUn_2_0; errBMskUn_3_0; errBMskUn_4_0; errBMskUn_5_0],...
%         [errWienerUn_1_0; errWienerUn_2_0; errWienerUn_3_0; errWienerUn_4_0; errWienerUn_5_0],...
%         [errMMSEUn_1_0; errMMSEUn_2_0; errMMSEUn_3_0; errMMSEUn_4_0; errMMSEUn_5_0]], 'positions', [18 21 24],...
%         'colors', 'r');

%     -- 5dB
% 	hold on
%     h1 = boxplot([[errBMskUn_1_5; errBMskUn_2_5; errBMskUn_3_5; errBMskUn_4_5; errBMskUn_5_5],...
%         [errWienerUn_1_5; errWienerUn_2_5; errWienerUn_3_5; errWienerUn_4_5; errWienerUn_5_5],...
%         [errMMSEUn_1_5; errMMSEUn_2_5; errMMSEUn_3_5; errMMSEUn_4_5; errMMSEUn_5_5]], 'positions', [27 30 33],...
%         'Labels', {'MB', 'Wiener', 'MMSE'}, 'colors', 'b');    
    
%     -- 10dB
%     hold on;
%     h5 = boxplot([[errBMskUn_1_10p; errBMskUn_2_10p; errBMskUn_3_10p; errBMskUn_4_10p; errBMskUn_5_10p],...
%         [errWienerUn_1_10p; errWienerUn_2_10p; errWienerUn_3_10p; errWienerUn_4_10p; errWienerUn_5_10p],...
%         [errMMSEUn_1_10p; errMMSEUn_2_10p; errMMSEUn_3_10p; errMMSEUn_4_10p; errMMSEUn_5_10p]], 'positions', [36 39 42],...
%         'Labels', {'MB', 'WN', 'MM'}, 'colors', 'k');

%     h5 = boxplot([[errMMSEUn_1_10p; errMMSEUn_2_10p; errMMSEUn_3_10p; errMMSEUn_4_10p; errMMSEUn_5_10p],...
%         [errWienerUn_1_10p; errWienerUn_2_10p; errWienerUn_3_10p; errWienerUn_4_10p; errWienerUn_5_10p],...
%         [errBMskUn_1_10p; errBMskUn_2_10p; errBMskUn_3_10p; errBMskUn_4_10p; errBMskUn_5_10p]], 'positions', [4 13 22],...
%         'Labels', {'-10', '-5', '0'}, 'colors', 'k');
    



    % -- BMsk
    figure 
    h4 = boxplot([[errBMskUn_1_10n; errBMskUn_2_10n; errBMskUn_3_10n; errBMskUn_4_10n; errBMskUn_5_10n; errBMskUn_6_10n],...
        [errBMskUn_1_5n; errBMskUn_2_5n; errBMskUn_3_5n; errBMskUn_4_5n; errBMskUn_5_5n; errBMskUn_6_5n],...
        [mean(errBMskUn_1_0); mean(errBMskUn_2_0); mean(errBMskUn_3_0); mean(errBMskUn_4_0); mean(errBMskUn_5_0); mean(errBMskUn_6_0)],...
        [mean(errBMskUn_1_5); mean(errBMskUn_2_5); mean(errBMskUn_3_5); mean(errBMskUn_4_5); mean(errBMskUn_5_5); mean(errBMskUn_6_5)],...
        [mean(errBMskUn_1_10p); mean(errBMskUn_2_10p); mean(errBMskUn_3_10p); mean(errBMskUn_4_10p); mean(errBMskUn_5_10p); mean(errBMskUn_6_10p)]], 'positions', [0 27 54 81 108],...
        'Labels', {'-10', '-5', '0', '5', '10'}, 'colors', 'g', 'width',5);
    
    hold on

    % -- Wiener
    h3 = boxplot([[errWienerUn_1_10n; errWienerUn_2_10n; errWienerUn_3_10n; errWienerUn_4_10n; errWienerUn_5_10n; errWienerUn_6_10n],...
        [errWienerUn_1_5n; errWienerUn_2_5n; errWienerUn_3_5n; errWienerUn_4_5n; errWienerUn_5_5n; errWienerUn_6_5n],...
        [mean(errWienerUn_1_0); mean(errWienerUn_2_0); mean(errWienerUn_3_0); mean(errWienerUn_4_0); mean(errWienerUn_5_0); mean(errWienerUn_6_0)],...
        [mean(errWienerUn_1_5); mean(errWienerUn_2_5); mean(errWienerUn_3_5); mean(errWienerUn_4_5); mean(errWienerUn_5_5); mean(errWienerUn_6_5)],...
        [mean(errWienerUn_1_10p); mean(errWienerUn_2_10p); mean(errWienerUn_3_10p); mean(errWienerUn_4_10p); mean(errWienerUn_5_10p); mean(errWienerUn_6_10p)]], 'positions', [9 36 63 90 117],...
        'Labels', {'-10', '-5', '0', '5', '10'}, 'colors', 'b', 'width',5);    
    
    
    % -- MMSE
    h2 = boxplot([[errMMSEUn_1_10n; errMMSEUn_2_10n; errMMSEUn_3_10n; errMMSEUn_4_10n; errMMSEUn_5_10n; errMMSEUn_6_10n],...
        [errMMSEUn_1_5n; errMMSEUn_2_5n; errMMSEUn_3_5n; errMMSEUn_4_5n; errMMSEUn_5_5n; errMMSEUn_6_5n],...
        [mean(errMMSEUn_1_0); mean(errMMSEUn_2_0); mean(errMMSEUn_3_0); mean(errMMSEUn_4_0); mean(errMMSEUn_5_0); mean(errMMSEUn_6_0)],...
        [mean(errMMSEUn_1_5); mean(errMMSEUn_2_5); mean(errMMSEUn_3_5); mean(errMMSEUn_4_5); mean(errMMSEUn_5_5); mean(errMMSEUn_6_5)],...
        [mean(errMMSEUn_1_10p); mean(errMMSEUn_2_10p); mean(errMMSEUn_3_10p); mean(errMMSEUn_4_10p); mean(errMMSEUn_5_10p); mean(errMMSEUn_6_10p)]], 'positions', [18 45 72 99 126],...
        'Labels', {'-10', '-5', '0', '5', '10'}, 'colors', 'k', 'width',5);      
    
    
%     axis([-1 43 -15 15])
%     legend([h4(5,1),h3(5,1),h2(5,1), h1(5,1), h5(5,1)], {'-10dB','-5dB','0dB','5dB','10dB'})
%     xlabel('Técnicas')
%     ylabel('$M_F$','Interpreter','latex')
    
    axis([-5 132 -15 15])
    legend([h4(5,1),h3(5,1),h2(5,1)], {'Máscara Binária','Wiener','MMSE'})
    xlabel('SNR[dB]')
    ylabel('$M_F$','Interpreter','latex')
    
    
set(gca,'FontSize',22);
h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
print(gcf, '-dpdf', strcat('Metrica_opt1_'));
% 
%     
%     
%     
%     
%     
    
    %%
    
%     fact = -1;
%     
%     [~,I25nU_1] = min(abs(100*curveUn_1(:,2)-0));
%     [~,I25pU_1] = min(abs(100*curveUn_1(:,2)-50));
%     
%     [~,I25nM_1] = min(abs(100*curveMMSE_1(:,2)-0));
%     [~,I25pM_1] = min(abs(100*curveMMSE_1(:,2)-50));
%     
%     [~,I25nB_1] = min(abs(100*curveBMsk_1(:,2)-0));
%     [~,I25pB_1] = min(abs(100*curveBMsk_1(:,2)-50));
% 
%     [~,I25nW_1] = min(abs(100*curveWiener_1(:,2)-0));
%     [~,I25pW_1] = min(abs(100*curveWiener_1(:,2)-50));    
%     
%     curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
%     errBMskUn_1_25   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));
%     
%     curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
%     errWienerUn_1_25  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
%     
%     curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
%     errMMSEUn_1_25 = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
% 
%     
%     
%     [~,I25nU_2] = min(abs(100*curveUn_2(:,2)-0));
%     [~,I25pU_2] = min(abs(100*curveUn_2(:,2)-50));
%     
%     [~,I25nM_2] = min(abs(100*curveMMSE_2(:,2)-0));
%     [~,I25pM_2] = min(abs(100*curveMMSE_2(:,2)-50));
%     
%     [~,I25nB_2] = min(abs(100*curveBMsk_2(:,2)-0));
%     [~,I25pB_2] = min(abs(100*curveBMsk_2(:,2)-50));
% 
%     [~,I25nW_2] = min(abs(100*curveWiener_2(:,2)-0));
%     [~,I25pW_2] = min(abs(100*curveWiener_2(:,2)-50));    
%     
%     curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
%     errBMskUn_2_25   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
%     
%     curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
%     errWienerUn_2_25  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
%     
%     curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
%     errMMSEUn_2_25 = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));
% 
%     
%     
%     [~,I25nU_3] = min(abs(100*curveUn_3(:,2)-0));
%     [~,I25pU_3] = min(abs(100*curveUn_3(:,2)-50));
%     
%     [~,I25nM_3] = min(abs(100*curveMMSE_3(:,2)-0));
%     [~,I25pM_3] = min(abs(100*curveMMSE_3(:,2)-50));
%     
%     [~,I25nB_3] = min(abs(100*curveBMsk_3(:,2)-0));
%     [~,I25pB_3] = min(abs(100*curveBMsk_3(:,2)-50));
% 
%     [~,I25nW_3] = min(abs(100*curveWiener_3(:,2)-0));
%     [~,I25pW_3] = min(abs(100*curveWiener_3(:,2)-50));    
%     
%     curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
%     errBMskUn_3_25   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
%     
%     curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
%     errWienerUn_3_25  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
%     
%     curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
%     errMMSEUn_3_25 = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    
%     
% 
%     
%     
%     
% %     hold on;
% %     h2 = boxplot([[errMMSEUn_1_25; errMMSEUn_2_25; errMMSEUn_3_25],...
% %         [errWienerUn_1_25; errWienerUn_2_25; errWienerUn_3_25],...
% %         [errBMskUn_1_25; errBMskUn_2_25; errBMskUn_3_25]], 'positions', [9 12 15],...
% %         'Labels', {'MMSE', 'Wiener', 'Máscara Binária'}, 'colors', 'r');
%     figure
%     h2 = boxplot([[errMMSEUn_1_25; errMMSEUn_2_25; errMMSEUn_3_25],...
%         [errWienerUn_1_25; errWienerUn_2_25; errWienerUn_3_25],...
%         [errBMskUn_1_25; errBMskUn_2_25; errBMskUn_3_25]], 'positions', [0 3 6],...
%         'colors', 'r');
%     
%     
% %     xlabel('Técnicas')
% %     ylabel('Distancia relativa ao sinal não-processado (25)')
% %     
%     % ------- center of 25% for subj. 1
% 
% 
% 
% 
% 
% 
%     % ------- center of 50% for subj. 1 (in terms of intelligibility)
%     
%     [~,I50U_1] = min(abs(100*curveUn_1(:,2)-50));
%     [~,I25nU_1] = min(abs(100*curveUn_1(:,2)-25));
%     [~,I25pU_1] = min(abs(100*curveUn_1(:,2)-75));
%     
%     [~,I50M_1] = min(abs(100*curveMMSE_1(:,2)-50));
%     [~,I25nM_1] = min(abs(100*curveMMSE_1(:,2)-25));
%     [~,I25pM_1] = min(abs(100*curveMMSE_1(:,2)-75));
%     
%     [~,I50B_1] = min(abs(100*curveBMsk_1(:,2)-50));
%     [~,I25nB_1] = min(abs(100*curveBMsk_1(:,2)-25));
%     [~,I25pB_1] = min(abs(100*curveBMsk_1(:,2)-75));
% 
%     [~,I50W_1] = min(abs(100*curveWiener_1(:,2)-50));
%     [~,I25nW_1] = min(abs(100*curveWiener_1(:,2)-25));
%     [~,I25pW_1] = min(abs(100*curveWiener_1(:,2)-75));    
%     
%     curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
%     errBMskUn_1   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));
%     
%     curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
%     errWienerUn_1  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
%     
%     curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
%     errMMSEUn_1 = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
% 
% 
%     
%     [~,I25nU_2] = min(abs(100*curveUn_2(:,2)-25));
%     [~,I25pU_2] = min(abs(100*curveUn_2(:,2)-75));
%     
%     [~,I25nM_2] = min(abs(100*curveMMSE_2(:,2)-25));
%     [~,I25pM_2] = min(abs(100*curveMMSE_2(:,2)-75));
%     
%     [~,I25nB_2] = min(abs(100*curveBMsk_2(:,2)-25));
%     [~,I25pB_2] = min(abs(100*curveBMsk_2(:,2)-75));
% 
%     [~,I25nW_2] = min(abs(100*curveWiener_2(:,2)-25));
%     [~,I25pW_2] = min(abs(100*curveWiener_2(:,2)-75));    
%     
%     curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
%     errBMskUn_2   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
%     
%     curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
%     errWienerUn_2  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
%     
%     curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
%     errMMSEUn_2 = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));
% 
% 
%     
%     [~,I25nU_3] = min(abs(100*curveUn_3(:,2)-25));
%     [~,I25pU_3] = min(abs(100*curveUn_3(:,2)-75));
%     
%     [~,I25nM_3] = min(abs(100*curveMMSE_3(:,2)-25));
%     [~,I25pM_3] = min(abs(100*curveMMSE_3(:,2)-75));
%     
%     [~,I25nB_3] = min(abs(100*curveBMsk_3(:,2)-25));
%     [~,I25pB_3] = min(abs(100*curveBMsk_3(:,2)-75));
% 
%     [~,I25nW_3] = min(abs(100*curveWiener_3(:,2)-25));
%     [~,I25pW_3] = min(abs(100*curveWiener_3(:,2)-75));    
%     
%     curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
%     errBMskUn_3   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
%     
%     curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
%     errWienerUn_3  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
%     
%     curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
%     errMMSEUn_3 = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    
%     
%     
%     hold on
%     h1 = boxplot([[errMMSEUn_1; errMMSEUn_2; errMMSEUn_3],...
%         [errWienerUn_1; errWienerUn_2; errWienerUn_3],...
%         [errBMskUn_1; errBMskUn_2; errBMskUn_3]], 'positions', [9 12 15],...
%         'Labels', {'MMSE', 'Wiener', 'Máscara Binária'}, 'colors', 'b');
% 
% %     xlabel('Técnicas')
% %     ylabel('Distancia relativa ao sinal não-processado (50\%)')
% 
%        
%     
%     
%     
%     % ------- center of 75% for subj. 1
% 
%     
%     [~,I25nU_1] = min(abs(100*curveUn_1(:,2)-50));
%     [~,I25pU_1] = min(abs(100*curveUn_1(:,2)-100));
%     
%     [~,I25nM_1] = min(abs(100*curveMMSE_1(:,2)-50));
%     [~,I25pM_1] = min(abs(100*curveMMSE_1(:,2)-100));
%     
%     [~,I25nB_1] = min(abs(100*curveBMsk_1(:,2)-50));
%     [~,I25pB_1] = min(abs(100*curveBMsk_1(:,2)-100));
% 
%     [~,I25nW_1] = min(abs(100*curveWiener_1(:,2)-50));
%     [~,I25pW_1] = min(abs(100*curveWiener_1(:,2)-100));    
%     
%     curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
%     errBMskUn_1_75   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));
%     
%     curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
%     errWienerUn_1_75  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
%     
%     curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
%     errMMSEUn_1_75 = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
% 
%     
%     
%     [~,I25nU_2] = min(abs(100*curveUn_2(:,2)-50));
%     [~,I25pU_2] = min(abs(100*curveUn_2(:,2)-100));
%     
%     [~,I25nM_2] = min(abs(100*curveMMSE_2(:,2)-50));
%     [~,I25pM_2] = min(abs(100*curveMMSE_2(:,2)-100));
%     
%     [~,I25nB_2] = min(abs(100*curveBMsk_2(:,2)-50));
%     [~,I25pB_2] = min(abs(100*curveBMsk_2(:,2)-100));
% 
%     [~,I25nW_2] = min(abs(100*curveWiener_2(:,2)-50));
%     [~,I25pW_2] = min(abs(100*curveWiener_2(:,2)-100));    
%     
%     curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
%     errBMskUn_2_75   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
%     
%     curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
%     errWienerUn_2_75  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
%     
%     curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
%     errMMSEUn_2_75 = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));
% 
%     
%     
%     [~,I25nU_3] = min(abs(100*curveUn_3(:,2)-50));
%     [~,I25pU_3] = min(abs(100*curveUn_3(:,2)-100));
%     
%     [~,I25nM_3] = min(abs(100*curveMMSE_3(:,2)-50));
%     [~,I25pM_3] = min(abs(100*curveMMSE_3(:,2)-100));
%     
%     [~,I25nB_3] = min(abs(100*curveBMsk_3(:,2)-50));
%     [~,I25pB_3] = min(abs(100*curveBMsk_3(:,2)-100));
% 
%     [~,I25nW_3] = min(abs(100*curveWiener_3(:,2)-50));
%     [~,I25pW_3] = min(abs(100*curveWiener_3(:,2)-100));    
%     
%     curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
%     errBMskUn_3_75   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
%     
%     curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
%     errWienerUn_3_75  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
%     
%     curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
%     errMMSEUn_3_75 = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    
%     
% 
%     
%     
%     
%     hold on;
%     h3 = boxplot([[errMMSEUn_1_75; errMMSEUn_2_75; errMMSEUn_3_75],...
%         [errWienerUn_1_75; errWienerUn_2_75; errWienerUn_3_75],...
%         [errBMskUn_1_75; errBMskUn_2_75; errBMskUn_3_75]], 'positions', [18 21 24],...
%         'Labels', {'MMSE', 'Wiener', 'MB'}, 'colors', 'g');
% 
% %     h3 = boxplot([[errMMSEUn_1_75; errMMSEUn_2_75; errMMSEUn_3_75],...
% %         [errWienerUn_1_75; errWienerUn_2_75; errWienerUn_3_75],...
% %         [errBMskUn_1_75; errBMskUn_2_75; errBMskUn_3_75]], 'positions', [18 21 24],...
% %         'colors', 'g', 'Orientation','vertical');
%     
%     
%     axis([-1 25 -20 20])
%     legend([h2(5,1),h1(5,1),h3(5,1)], {'25%','50%','75%'})
%     xlabel('Técnicas')
%     ylabel('I')
%     
%     % ------- center of 25% for subj. 1
% 
%     
%     
%     
%     
%     %%% ------- AGRUPATE IN ALL ONE BOXPLOT!!
%     
%     
% %     plot(curveUn_1(:,1), curveUn_1(:,2))
% %     hold on
% %     plot(curveUnR_1(:,1), curveUnR_1(:,2),'r')
% %     [~,I0] = min(abs(curveUnR_1(:,1)-0));
% %     [~,I25p] = min(abs(curveUnR_1(:,1)-.25));
% %     [~,I25n] = min(abs(curveUnR_1(:,1)+.25));
% %     
% %     [~,I100n] = min(abs(curveUnR_1(:,1)+1));
% %     
% %     
% %     
% %     Y0Un = curveUnR_1(I0,2);
% %     Y25pUn = curveUnR_1(I25p,2);
% %     Y25nUn = curveUnR_1(I25n,2);
% %     Y100nUn = curveUnR_1(I100n,2);
%     
% %     SRTUnpos = I;
% 
% % set(gca,'FontSize',22);
% % h=gcf;
% % set(h,'PaperOrientation','landscape');
% % set(h,'PaperUnits','normalized');
% % set(h,'PaperPosition', [0 0 1 1]);
% % print(gcf, '-dpdf', strcat('DistanciaNaoProc'));
% 
% 
% 
