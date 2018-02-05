function [MValStoi_scoresLeft, MValSrmrCi_scores, MValNCM_scores, MValStoi_scoresLeft_Un, MValSrmrCi_scores_Un, MValNCM_scores_Un, MSNRMeas_scoresLeft] = GetMonoauralMetrics(Gain, Method, Noise, AZN, Nsnr)
% function [MValStoi_scoresLeft, MValSrmrCi_scores, MValNCM_scores, MValStoi_scoresLeft_Un, MValSrmrCi_scores_Un, MValNCM_scores_Un, snr_front_left_Meas] = GetMonoauralMetrics(Gain, Method, Noise, AZN, Nsnr)
% Get monoraural metrics from .mat file
% Output
% Stoi_scores_1chan 
% SrmrCi_scores_1chan
% NCM_scores_1chan
% Stoi_scores_1chan_Un
% SrmrCi_scores_1chan_Un
% NCM_scores_1chan_Un
% MSNRMeas_scoresLeft
% Input
% Gain       -       'Wiener' / 'MMSE' / 'BMsk'
% Method     -       'npsd_rs' / 'unbiased_mmse'
% Noise      -       'ICRA' / 'babble' / 'SSN_IEEE' 
% AZN        -       'Wiener' / 'MMSE' / 'BMsk'
% Nsnr       -       Number of SNR tested

if (AZN == -45)
    AZN = 1;
elseif (AZN == 0)
    AZN = 2;
else
    AZN = 3;
end

nameFile = strcat(Gain,'_',Method,'_',Noise);
load(nameFile);


%% Get SNR measure on ear
MSNRMeas_scoresLeft = ...
    zeros(Nsnr,size(Stoi_scoresLeft,1)*size(Stoi_scoresLeft,2));
snr_front_left_Meas = [];
for snr=1:Nsnr
    for k=1:size(Stoi_scoresLeft,1)
        for p=1:size(Stoi_scoresLeft,2)
            
            snr_front_left_Meas = ...
                [snr_front_left_Meas snr_front_left{k,p}(snr,AZN)];
        end
    end
    MSNRMeas_scoresLeft(snr,:) = snr_front_left_Meas;
    snr_front_left_Meas = [];
end
    
%% STOI

% 3. STOI_left
MValStoi_scoresLeft = ...
    zeros(Nsnr,size(Stoi_scoresLeft,1)*size(Stoi_scoresLeft,2));
ValStoi_scoresLeft = [];
for snr=1:Nsnr
    for k=1:size(Stoi_scoresLeft,1)
        for p=1:size(Stoi_scoresLeft,2)
       
            ValStoi_scoresLeft = ...
                [ValStoi_scoresLeft Stoi_scores_1chan{k,p}(snr,AZN)];
            
        end
    end
    
    % Vector of values related to each signal
    % (total of 30 audios x 10 listas)
    MValStoi_scoresLeft(snr,:) = ValStoi_scoresLeft;
    ValStoi_scoresLeft = [];
end

% STOI unprocessed signal
MValStoi_scoresLeft_Un = ...
    zeros(Nsnr,size(Stoi_scoresLeft_Un,1)*size(Stoi_scoresLeft_Un,2));

if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain)) == 1
    ValStoi_scoresLeft_Un = [];
    for snr=1:Nsnr
        for k=1:size(Stoi_scoresLeft,1)
            for p=1:size(Stoi_scoresLeft,2)
       
                ValStoi_scoresLeft_Un = ...
                    [ValStoi_scoresLeft_Un Stoi_scoresLeft_Un{k,p}(snr,AZN)];
            
            end
        end
        
        % Vector of values related to each signal
        % (total of 30 audios x 10 listas)
        MValStoi_scoresLeft_Un(snr,:) = ValStoi_scoresLeft_Un;
        ValStoi_scoresLeft_Un = [];        
    end
end


%% SRMR-CI

% 4. SRMR_left
MValSrmrCi_scores = ...
    zeros(Nsnr,size(SrmrCi_scores,1)*size(SrmrCi_scores,2));
ValSrmrCi_scores = [];

for snr=1:Nsnr
    for k=1:size(SrmrCi_scores,1)
        for p=1:size(SrmrCi_scores,2)
        
            ValSrmrCi_scores = ...
                [ValSrmrCi_scores SrmrCi_scores_1chan{k,p}(snr,AZN)];
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValSrmrCi_scores(snr,:) = ValSrmrCi_scores;
    ValSrmrCi_scores = [];
end

% 4. SRMR_left unprocessed signal
MValSrmrCi_scores_Un = ...
    zeros(Nsnr,size(SrmrCi_scores_Un,1)*size(SrmrCi_scores_Un,2));

if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain)) == 1
    ValSrmrCi_scores_Un = [];
    for snr=1:Nsnr
        for k=1:size(SrmrCi_scores,1)
            for p=1:size(SrmrCi_scores,2)
        
                ValSrmrCi_scores_Un = ...
                    [ValSrmrCi_scores_Un SrmrCi_scores_Un{k,p}(snr,AZN)];
            
            end
        end
        % Vector of values related to each signal 
        % (total of 30 audios x 10 listas)
        MValSrmrCi_scores_Un(snr,:) = ValSrmrCi_scores_Un;
        ValSrmrCi_scores_Un = [];        
    end
end



%% NCM

% 4. NCM_left
MValNCM_scores = ...
    zeros(Nsnr,size(NCM_scores_1chan,1)*size(NCM_scores_1chan,2));
ValNCM_scores = [];

for snr=1:Nsnr
    for k=1:size(NCM_scores_1chan,1)
        for p=1:size(NCM_scores_1chan,2)
        
            ValNCM_scores = ...
                [ValNCM_scores NCM_scores_1chan{k,p}(snr,AZN)];
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValNCM_scores(snr,:) = ValNCM_scores;
    ValNCM_scores = [];
end

% 4. NCM unprocessed signal
MValNCM_scores_Un = ...
    zeros(Nsnr,size(NCM_scores_Un,1)*size(NCM_scores_Un,2));

if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain)) == 1
    ValNCM_scores_Un = [];
    for snr=1:Nsnr
        for k=1:size(NCM_scores_Un,1)
            for p=1:size(NCM_scores_Un,2)
        
                ValNCM_scores_Un = ...
                    [ValNCM_scores_Un NCM_scores_Un{k,p}(snr,AZN)];
            
            end
        end
        % Vector of values related to each signal 
        % (total of 30 audios x 10 listas)
        MValNCM_scores_Un(snr,:) = ValNCM_scores_Un;
        ValNCM_scores_Un = [];        
    end
end


end