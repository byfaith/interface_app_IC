% function [PesqScores, SRMRScores, UnPesqScores, UnSRMRScores] = ComputeAverageValues(Gain, Method, List, Noise)
function [PesqScoresRep, SrmrScoresRep, UnPesqScoresRep, UnSrmrScoresRep, CleanSrmrScoresRep] = ComputeAverageValues(Gain, Method, List, Noise)

% [PesqScores, SRMRScores] = ComputeAverageValues(nameFileSearch)
% PesqScores:           Average pesq scores
% SRMRScores:           Average SRMR scores
% UnPesqScores:         Average pesq scores (unprocessed audio)
% UnSRMRScores:         Average SRMR scores (unprocessed audio)
% CleanSrmrScoresRep    Average SRMR scores (clean audio)
% 
% Gain = 'Wiener' / 'MMSE' / 'Clean'
% Method = 'npsd_rs' / 'unbiased_mmse' / 'Clean'
% List = '1' / '2' / '3' / ... / 10;
% Noise = 'ICRA' / 'babble' 

if strcmp('Wiener',Gain) == 1 || strcmp('MMSE',Gain) == 1
    nameFileSearch = strcat(Gain,'_',Method,'_List',List,'_',Noise,'.mat');   
    load(nameFileSearch)
    VectorSNR = [-15 -10 -5 0 5 10 15 20]';
    % n = 5;   %n = 4
    n = 2;
    NS = 10;

    %% Pesq
%     for p=1:length(VectorSNR)   % For each SNR
%         for r=1:1:NS            % For each signal
%             for q=1:1:n         % For each repetition
%                 PesqPerRep(q) = Pesq_scores{p,q,r};
%             end
%             PesqScoresRep(p,r) = mean(PesqPerRep(q));      %For each SNR, each sig
%         end
%     end
%     PesqScores = mean(PesqScoresRep,2);                 % Average pesq scores
    PesqPerRep = 0;
    PesqScoresRep = 0;
    PesqScores = 0;
    %% Srmr
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
                SrmrPerRep(q) = SrmrCi_scores{p,q,r};
            end
            SrmrScoresRep(p,r) = mean(SrmrPerRep(q));      %For each SNR, each sig
        end
    end
    SRMRScores = mean(SrmrScoresRep,2);                 % Average SRMR scores


%% ------------------------------------------------------------------
%% ------------------------------------------------------------------
    %% Unprocessed
    clear Pesq_scores
    nameFileUnproc = strcat('_List',List,'_',Noise,'_','NaoProcessado','.mat');
    load(nameFileUnproc);

    %% Pesq
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
                UnPesqPerRep(q) = Pesq_scores{p,q,r};
            end
            UnPesqScoresRep(p,r) = mean(UnPesqPerRep(q));      %For each SNR, each sig
        end
    end
    UnPesqScores = mean(UnPesqScoresRep,2);                 % Average pesq scores

    %% Srmr
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
                UnSrmrPerRep(q) = SrmrCi_scores{p,q,r};
            end
            UnSrmrScoresRep(p,r) = mean(UnSrmrPerRep(q));      %For each SNR, each sig
        end
    end
    UnSRMRScores = mean(UnSrmrScoresRep,2);                 % Average SRMR scores


    CleanSrmrScoresRep = [];

%% Clean file
elseif strcmp('Clean',Gain) == 1
    
    nameFileUnproc = strcat('_List',List,'_',Noise,'_','Clear','.mat');
    load(nameFileUnproc);
    VectorSNR = [-15 -10 -5 0 5 10 15 20]';
    % n = 5;   %n = 4
    n = 5;
    NS = 10;    
    
    % Srmr
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
                ClearSrmrPerRep(q) = SrmrCi_scores_Clear{p,q,r};
            end
            CleanSrmrScoresRep(p,r) = mean(ClearSrmrPerRep(q));      %For each SNR, each sig
        end
    end
    CleanSRMRScores = mean(CleanSrmrScoresRep,2);                 % Average SRMR scores    
    
    PesqScoresRep = [];
    SrmrScoresRep = [];
    UnPesqScoresRep = [];
    UnSrmrScoresRep = [];
end

end
