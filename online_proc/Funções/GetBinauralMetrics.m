function [MValPesq_scoresLeft, MValPesq_scoresLeft_Un, MValsnrseg_meanLeft, MValsnrseg_meanLeft_Un, MValStoi_scoresLeft, MValStoi_scoresLeft_Un, MValSrmrCi_scores, MValSrmrCi_scores_Un] = GetBinauralMetrics(Gain, Method, Noise, AZN, Nsnr)
% function [MValPesq_scoresLeft, MValPesq_scoresLeft_Un, MValsnrseg_meanLeft, MValsnrseg_meanLeft_Un, MValStoi_scoresLeft, MValStoi_scoresLeft_Un, MValSrmrCi_scores, MValSrmrCi_scores_Un] = GetBinauralMetrics(Gain, Method, Noise, AZN, Nsnr)
% Get binaural metrics from .mat file
% Output
% MValPesq_scoresLeft
% MValPesq_scoresLeft_Un
% MValsnrseg_meanLeft
% MValsnrseg_meanLeft_Un
% MValStoi_scoresLeft 
% MValStoi_scoresLeft_Un
% MValSrmrCi_scores
% MValSrmrCi_scores_Un
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


%% Pesq (N-90 degree)

% 1. Pesq_left
MValPesq_scoresLeft = ...
    zeros(Nsnr,size(Pesq_scoresLeft,1)*10);


ValPesq_scoresLeft = [];
for snr=1:Nsnr
    for k=1:size(Pesq_scoresLeft,1)
%         for p=1:size(Pesq_scoresLeft,2)
        for p=1:10
        
            ValPesq_scoresLeft = ...
                [ValPesq_scoresLeft Pesq_scoresLeft{k,p}(snr,AZN)];
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValPesq_scoresLeft(snr,:) = ValPesq_scoresLeft;
    ValPesq_scoresLeft = [];
end

% 1. Pesq_left - unprocessed
MValPesq_scoresLeft_Un = ...
    zeros(Nsnr,size(Pesq_scoresLeft,1)*10);
ValPesq_scoresLeft_Un = [];
for snr=1:Nsnr
    for k=1:size(Pesq_scoresLeft_Un,1)
%         for p=1:size(Pesq_scoresLeft_Un,2)
        for p=1:10        
            if(strcmp('BMsk',Gain)==1)
                
                ValPesq_scoresLeft_Un = ...
                    [ValPesq_scoresLeft_Un Pesq_scoresLeft_Un{k,p}(snr,1)];
                
            else
                 
                ValPesq_scoresLeft_Un = ...
                    [ValPesq_scoresLeft_Un Pesq_scoresLeft_Un{k,p}(snr,AZN)];
                
            end
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValPesq_scoresLeft_Un(snr,:) = ValPesq_scoresLeft_Un;
    ValPesq_scoresLeft_Un = [];
end


%% SNR segmental

% 2. SNRseg_left
MValsnrseg_meanLeft = ...
    zeros(Nsnr,size(Pesq_scoresLeft,1)*10);
Valsnrseg_meanLeft = [];
for snr=1:Nsnr
    for k=1:size(Pesq_scoresLeft,1)
%         for p=1:size(Pesq_scoresLeft,2)
        for p=1:10
                  
            Valsnrseg_meanLeft = ...
                [Valsnrseg_meanLeft snrseg_meanLeft{k,p}(snr,AZN)];    
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValsnrseg_meanLeft(snr,:) = Valsnrseg_meanLeft;
    Valsnrseg_meanLeft = [];
end

% 2. SNRseg_left - unprocessed
MValsnrseg_meanLeft_Un = ...
    zeros(Nsnr,size(snrseg_meanLeft_Un,1)*10);
Valsnrseg_meanLeft_Un = [];
for snr=1:Nsnr
    for k=1:size(snrseg_meanLeft_Un,1)
%         for p=1:size(snrseg_meanLeft_Un,2)
        for p=1:10
            
            if(strcmp('BMsk',Gain)==1)
                Valsnrseg_meanLeft_Un = ...
                    [Valsnrseg_meanLeft_Un snrseg_meanLeft_Un{k,p}(snr,1)];
            else
                Valsnrseg_meanLeft_Un = ...
                    [Valsnrseg_meanLeft_Un snrseg_meanLeft_Un{k,p}(snr,AZN)];                
            end
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValsnrseg_meanLeft_Un(snr,:) = Valsnrseg_meanLeft_Un;
    Valsnrseg_meanLeft_Un = [];
end


%% STOI

% 3. STOI_left
MValStoi_scoresLeft = ...
    zeros(Nsnr,size(Stoi_scoresLeft,1)*10);
ValStoi_scoresLeft = [];
for snr=1:Nsnr
    for k=1:size(Pesq_scoresLeft,1)
%         for p=1:size(Pesq_scoresLeft,2)
        for p=1:10
        
            ValStoi_scoresLeft = ...
                [ValStoi_scoresLeft Stoi_scoresLeft{k,p}(snr,AZN)];
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValStoi_scoresLeft(snr,:) = ValStoi_scoresLeft;
    ValStoi_scoresLeft = [];
end

% 3. STOI_left - unprocessed
MValStoi_scoresLeft_Un = ...
    zeros(Nsnr,size(Stoi_scoresLeft_Un,1)*10);
ValStoi_scoresLeft_Un = [];
for snr=1:Nsnr
    for k=1:size(snrseg_meanLeft_Un,1)
%         for p=1:size(snrseg_meanLeft_Un,2)
        for p=1:10
            if(strcmp('BMsk',Gain)==1)
                ValStoi_scoresLeft_Un = ...
                    [ValStoi_scoresLeft_Un Stoi_scoresLeft_Un{k,p}(snr,1)];
            else
                ValStoi_scoresLeft_Un = ...
                    [ValStoi_scoresLeft_Un Stoi_scoresLeft_Un{k,p}(snr,AZN)];                
            end
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValStoi_scoresLeft_Un(snr,:) = ValStoi_scoresLeft_Un;
    ValStoi_scoresLeft_Un = [];
end


%% SRMR-CI

% 4. SRMR_left
MValSrmrCi_scores = ...
    zeros(Nsnr,size(SrmrCi_scores,1)*10);
ValSrmrCi_scores = [];
for snr=1:Nsnr
    for k=1:size(SrmrCi_scores,1)
%         for p=1:size(SrmrCi_scores,2)
        for p=1:10
        
            ValSrmrCi_scores = ...
                [ValSrmrCi_scores SrmrCi_scores{k,p}(snr,AZN)];
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValSrmrCi_scores(snr,:) = ValSrmrCi_scores;
    ValSrmrCi_scores = [];
end

% 4. SRMR_left - unprocessed
MValSrmrCi_scores_Un = ...
    zeros(Nsnr,size(SrmrCi_scores_Un,1)*10);
ValSrmrCi_scores_Un = [];
for snr=1:Nsnr
    for k=1:size(snrseg_meanLeft_Un,1)
%         for p=1:size(snrseg_meanLeft_Un,2)
        for p=1:10
            
            if(strcmp('BMsk',Gain)==1)
                ValSrmrCi_scores_Un = ...
                    [ValSrmrCi_scores_Un SrmrCi_scores_Un{k,p}(snr,1)];
            else
                ValSrmrCi_scores_Un = ...
                    [ValSrmrCi_scores_Un SrmrCi_scores_Un{k,p}(snr,AZN)];                
            end
            
        end
    end
    % Vector of values related to each signal 
    % (total of 30 audios x 10 listas)
    MValSrmrCi_scores_Un(snr,:) = ValSrmrCi_scores_Un;
    ValSrmrCi_scores_Un = [];
end


end