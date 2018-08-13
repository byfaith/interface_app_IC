
clear all
% Get values from approximated psychometric curve, then calculates relative
% error

rmpath('Adelaide')
rmpath('Rosana')
rmpath('p6')
[curveMMSE_1, curveUn_1, curveWiener_1, curveBMsk_1] = ...
    obtainPsiCurves('Marina2', 1, -20, 30);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS1'));


rmpath('Adelaide')
rmpath('Marina2')
rmpath('p6')
[curveMMSE_2, curveUn_2, curveWiener_2, curveBMsk_2] = ...
    obtainPsiCurves('Rosana', 1, 5, 30);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS2'));


rmpath('Marina2')
rmpath('Rosana')
rmpath('p6')
[curveMMSE_3, curveUn_3, curveWiener_3, curveBMsk_3] = ...
    obtainPsiCurves('Adelaide', 1, 0, 25);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS3'));


rmpath('Marina2')
rmpath('Rosana')
rmpath('Adelaide')
[curveMMSE_3, curveUn_3, curveWiener_3, curveBMsk_3] = ...
    obtainPsiCurves('l7', 1, 15, 40);

% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('logitS4'));


%% 
% Resample set of data based on higher vector
% ALL THE DATA ALL RESAMPLED BASED ON SIZE OF curveMMSE_2 (HIGHER VALUES)
% Error from subject 1
curveBMskR_1 = resample(curveBMsk_1(:,:), length(curveMMSE_1), length(curveBMsk_1));
curveWienerR_1 = resample(curveWiener_1(:,:), length(curveMMSE_1), length(curveWiener_1));
curveUnR_1 = resample(curveUn_1(:,:), length(curveMMSE_1), length(curveUn_1));

errBMskUn_1   = (curveBMskR_1(:,1) - curveUnR_1(:,1));
errWienerUn_1  = (curveWienerR_1(:,1) - curveUnR_1(:,1));
errMMSEUn_1 = (curveMMSE_1(:,1) - curveUnR_1(:,1));


% Error from subject 2
curveBMskR_2 = resample(curveBMsk_2(:,1), length(curveMMSE_2), length(curveBMsk_2));
curveWienerR_2 = resample(curveWiener_2(:,1), length(curveMMSE_2), length(curveWiener_2));
curveUnR_2 = resample(curveUn_2(:,1), length(curveMMSE_2), length(curveUn_2));

errBMskUn_2   = (curveBMskR_2 - curveUnR_2);
errWienerUn_2  = (curveWienerR_2 - curveUnR_2);
errMMSEUn_2 = (curveMMSE_2(:,1) - curveUnR_2);



% Error from subject 3
curveBMskR_3 = resample(curveBMsk_3(:,1), length(curveMMSE_3), length(curveBMsk_3));
curveWienerR_3 = resample(curveWiener_3(:,1), length(curveMMSE_3), length(curveWiener_3));
curveUnR_3 = resample(curveUn_3(:,1), length(curveMMSE_3), length(curveUn_3));

errBMskUn_3   = (curveBMskR_3 - curveUnR_3);
errWienerUn_3  = (curveWienerR_3 - curveUnR_3);
errMMSEUn_3 = (curveMMSE_3(:,1) - curveUnR_3);


% h1 = boxplot([[errMMSEUn_1; errMMSEUn_2; errMMSEUn_3],...
%     [errWienerUn_1; errWienerUn_2; errWienerUn_3],...
%     [errBMskUn_1; errBMskUn_2; errBMskUn_3]],...
%     'Labels', {'MMSE', 'Wiener', 'Máscara Binária'});
% 
% xlabel('Técnicas')
% ylabel('Distancia relativa ao sinal não-processado')



%% Discriminar por faixa de SNR


    % ------- center of 0SNR for subj. 1
    
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
    errBMskUn_1_0   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_0  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_0 = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)+2.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)-2.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)+2.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)-2.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)+2.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)-2.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)+2.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)-2.5)); 
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_0   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_0  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_0 = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)+2.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)-2.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)+2.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)-2.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)+2.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)-2.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)+2.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)-2.5));    
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_0   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_0  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_0 = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    

    
    
    % ------- center of 5 SNR for subj. 1
    
	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)-2.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)-7.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)-2.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)-7.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)-2.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)-7.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)-2.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)-7.5));  

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_5   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_5  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_5 = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)-2.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)-7.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)-2.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)-7.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)-2.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)-7.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)-2.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)-7.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_5   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_5  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_5 = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)-2.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)-7.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)-2.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)-7.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)-2.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)-7.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)-2.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)-7.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_5   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_5  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_5 = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));

    % ------- center of 5 SNR for subj. 1
     
    
    
    % ------- center of -5 SNR for subj. 1
    
	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)+7.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)+2.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)+7.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)+2.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)+7.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)+2.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)+7.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)+2.5));    

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_5n   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_5n  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_5n = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)+7.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)+2.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)+7.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)+2.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)+7.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)+2.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)+7.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)+2.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_5n   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_5n  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_5n = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)+7.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)+2.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)+7.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)+2.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)+7.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)+2.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)+7.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)+2.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_5n   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_5n  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_5n = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    

    % ------- center of -5 SNR for subj.     
    
    
    
    
	% ------- center of -10 SNR for subj. 1
    
	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)+12.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)+7.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)+12.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)+7.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)+12.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)+7.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)+12.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)+7.5));

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_10n   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_10n  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_10n = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)+12.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)+7.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)+12.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)+7.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)+12.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)+7.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)+12.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)+7.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_10n   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_10n  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_10n = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)+12.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)+7.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)+12.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)+7.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)+12.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)+7.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)+12.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)+7.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_10n   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_10n  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_10n = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    

    % ------- center of -10 SNR for subj. 1
    
    
    
    
    	% ------- center of 10 SNR for subj. 1
    
	fact = -1;
    
	[~,I25nU_1] = min(abs(curveUn_1(:,1)-7.5));
    [~,I25pU_1] = min(abs(curveUn_1(:,1)-12.5));

    [~,I25nM_1] = min(abs(curveMMSE_1(:,1)-7.5));
    [~,I25pM_1] = min(abs(curveMMSE_1(:,1)-12.5));
    
    [~,I25nB_1] = min(abs(curveBMsk_1(:,1)-7.5));
    [~,I25pB_1] = min(abs(curveBMsk_1(:,1)-12.5));

    [~,I25nW_1] = min(abs(curveWiener_1(:,1)-7.5));
    [~,I25pW_1] = min(abs(curveWiener_1(:,1)-12.5));  

	curveBMskR_1 = resample(curveBMsk_1(I25nB_1:I25pB_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveBMsk_1(I25nB_1:I25pB_1,1)));
    errBMskUn_1_10n   = fact.*(curveBMskR_1 - curveUn_1(I25nU_1:I25pU_1,1));

    curveWienerR_1 = resample(curveWiener_1(I25nW_1:I25pW_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveWiener_1(I25nW_1:I25pW_1,1)));    
    errWienerUn_1_10n  = fact.*(curveWienerR_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    curveMMSER_1 = resample(curveMMSE_1(I25nM_1:I25pM_1,1), length(curveUn_1(I25nU_1:I25pU_1,1)), length(curveMMSE_1(I25nM_1:I25pM_1,1)));    
    errMMSEUn_1_10n = fact.*(curveMMSER_1 - curveUn_1(I25nU_1:I25pU_1,1));
    
    
	[~,I25nU_2] = min(abs(100*curveUn_2(:,1)-7.5));
    [~,I25pU_2] = min(abs(100*curveUn_2(:,1)-12.5));
    
    [~,I25nM_2] = min(abs(100*curveMMSE_2(:,1)-7.5));
    [~,I25pM_2] = min(abs(100*curveMMSE_2(:,1)-12.5));
    
    [~,I25nB_2] = min(abs(100*curveBMsk_2(:,1)-7.5));
    [~,I25pB_2] = min(abs(100*curveBMsk_2(:,1)-12.5));

    [~,I25nW_2] = min(abs(100*curveWiener_2(:,1)-7.5));
    [~,I25pW_2] = min(abs(100*curveWiener_2(:,1)-12.5));
    
    curveBMskR_2 = resample(curveBMsk_2(I25nB_2:I25pB_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveBMsk_2(I25nB_2:I25pB_2,1)));
    errBMskUn_2_10n   = fact.*(curveBMskR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveWienerR_2 = resample(curveWiener_2(I25nW_2:I25pW_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveWiener_2(I25nW_2:I25pW_2,1)));    
    errWienerUn_2_10n  = fact.*(curveWienerR_2 - curveUn_2(I25nU_2:I25pU_2,1));
    
    curveMMSER_2 = resample(curveMMSE_2(I25nM_2:I25pM_2,1), length(curveUn_2(I25nU_2:I25pU_2,1)), length(curveMMSE_2(I25nM_2:I25pM_2,1)));    
    errMMSEUn_2_10n = fact.*(curveMMSER_2 - curveUn_2(I25nU_2:I25pU_2,1));

	
    [~,I25nU_3] = min(abs(100*curveUn_3(:,1)-7.5));
    [~,I25pU_3] = min(abs(100*curveUn_3(:,1)-12.5));
    
    [~,I25nM_3] = min(abs(100*curveMMSE_3(:,1)-7.5));
    [~,I25pM_3] = min(abs(100*curveMMSE_3(:,1)-12.5));
    
    [~,I25nB_3] = min(abs(100*curveBMsk_3(:,1)-7.5));
    [~,I25pB_3] = min(abs(100*curveBMsk_3(:,1)-12.5));

    [~,I25nW_3] = min(abs(100*curveWiener_3(:,1)-7.5));
    [~,I25pW_3] = min(abs(100*curveWiener_3(:,1)-12.5));
    
    curveBMskR_3 = resample(curveBMsk_3(I25nB_3:I25pB_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveBMsk_3(I25nB_3:I25pB_3,1)));
    errBMskUn_3_10n   = fact.*(curveBMskR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveWienerR_3 = resample(curveWiener_3(I25nW_3:I25pW_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveWiener_3(I25nW_3:I25pW_3,1)));    
    errWienerUn_3_10n  = fact.*(curveWienerR_3 - curveUn_3(I25nU_3:I25pU_3,1));
    
    curveMMSER_3 = resample(curveMMSE_3(I25nM_3:I25pM_3,1), length(curveUn_3(I25nU_3:I25pU_3,1)), length(curveMMSE_3(I25nM_3:I25pM_3,1)));    
    errMMSEUn_3_10n = fact.*(curveMMSER_3 - curveUn_3(I25nU_3:I25pU_3,1));    

    % ------- center of 10 SNR for subj. 1

	% -- -10dB
    figure
    h4 = boxplot([[errMMSEUn_1_10n; errMMSEUn_2_10n; errMMSEUn_3_10n],...
        [errWienerUn_1_10n; errWienerUn_2_10n; errWienerUn_3_10n],...
        [errBMskUn_1_10n; errBMskUn_2_10n; errBMskUn_3_10n]], 'positions', [0 3 6],...
        'Labels', {'MMSE', 'Wiener', 'MB'}, 'colors', 'm');

    
    % -- -5dB
    hold on;
    h3 = boxplot([[errMMSEUn_1_5n; errMMSEUn_2_5n; errMMSEUn_3_5n],...
        [errWienerUn_1_5n; errWienerUn_2_5n; errWienerUn_3_5n],...
        [errBMskUn_1_5n; errBMskUn_2_5n; errBMskUn_3_5n]], 'positions', [9 12 15],...
        'Labels', {'MMSE', 'Wiener', 'MB'}, 'colors', 'g');
    
    
    
    % -- 0dB
	hold on
    h2 = boxplot([[errMMSEUn_1_0; errMMSEUn_2_0; errMMSEUn_3_0],...
        [errWienerUn_1_0; errWienerUn_2_0; errWienerUn_3_0],...
        [errBMskUn_1_0; errBMskUn_2_0; errBMskUn_3_0]], 'positions', [18 21 24],...
        'colors', 'r');

    % -- 5dB
	hold on
    h1 = boxplot([[errMMSEUn_1_5; errMMSEUn_2_5; errMMSEUn_3_5],...
        [errWienerUn_1_5; errWienerUn_2_5; errWienerUn_3_5],...
        [errBMskUn_1_5; errBMskUn_2_5; errBMskUn_3_5]], 'positions', [27 30 33],...
        'Labels', {'MMSE', 'Wiener', 'Máscara Binária'}, 'colors', 'b');    
    
    % -- 10dB
    hold on;
    h5 = boxplot([[errMMSEUn_1_10n; errMMSEUn_2_10n; errMMSEUn_3_10n],...
        [errWienerUn_1_10n; errWienerUn_2_10n; errWienerUn_3_10n],...
        [errBMskUn_1_10n; errBMskUn_2_10n; errBMskUn_3_10n]], 'positions', [36 39 42],...
        'Labels', {'MMSE', 'Wiener', 'MB'}, 'colors', 'k');

    
    
    
    axis([-1 43 -.5 .5])
    legend([h4(5,1),h3(5,1),h2(5,1), h1(5,1), h5(5,1)], {'-10dB','-5dB','0dB','5dB','10dB'})
    xlabel('Técnicas')
    ylabel('I')
    
% set(gca,'FontSize',22);
% h=gcf;
% set(h,'PaperOrientation','landscape');
% set(h,'PaperUnits','normalized');
% set(h,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf', strcat('Metrica_opt1'));
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
