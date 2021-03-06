function [Pesq_scoresLeft, Pesq_scoresRight, SrmrCi_scores, Stoi_scoresLeft, Stoi_scoresRight, snr_meanLeft, snr_meanRight, snrseg_meanLeft, snrseg_meanRight, Pesq_scoresLeft_Un, Pesq_scoresRight_Un, SrmrCi_scores_Un, Stoi_scoresLeft_Un, Stoi_scoresRight_Un, snr_meanLeft_Un, snr_meanRight_Un, snrseg_meanLeft_Un, snrseg_meanRight_Un, Pesq_scores_1chan, SrmrCi_scores_1chan, Stoi_scores_1chan, snr_mean_1chan, snrseg_mean_1chan, NCM_scores_1chan, NCM_scores_Un, snr_front_left, snr_front_right] = ComputeAudios_TwoChannels(Gain, Method, FSnew, Noise, DIROUT, DIRSPEECH, DIRHRIR, DIRNOISE, NAMESPEECH, FlagBinauMono, SNREstAl, earref, SNR, AZN)
% function [Pesq_scoresLeft, Pesq_scoresRight, SrmrCi_scores, Stoi_scoresLeft, Stoi_scoresRight, snr_meanLeft, snr_meanRight, snrseg_meanLeft, snrseg_meanRight, Pesq_scoresLeft_Un, Pesq_scoresRight_Un, SrmrCi_scores_Un, Stoi_scoresLeft_Un, Stoi_scoresRight_Un, snr_meanLeft_Un, snr_meanRight_Un, snrseg_meanLeft_Un, snrseg_meanRight_Un, Pesq_scores_1chan, SrmrCi_scores_1chan, Stoi_scores_1chan, snr_mean_1chan, snrseg_mean_1chan, NCM_scores_1chan, NCM_scores_Un, snr_front_left, snr_front_right] = ComputeAudios_TwoChannels(Gain, Method, FSnew, Noise, DIROUT, DIRSPEECH, DIRHRIR, DIRNOISE, NAMESPEECH, FlagBinauMono)
% Function which generate scenario in a specific SNR, then filter signal
% based on choose algorithms
% Output
%   Pesq_scoresLeft
%   Pesq_scoresRight
%   SrmrCi_scores
%   Stoi_scoresLeft
%   Stoi_scoresRight
%   snr_meanLeft
%   snr_meanRight
%   snrseg_meanLeft
%   snrseg_meanRight
%   Pesq_scoresLeft_Un
%   Pesq_scoresRight_Un
%   SrmrCi_scores_Un
%   Stoi_scoresLeft_Un
%   Stoi_scoresRight_Un
%   snr_meanLeft_Un
%   snr_meanRight_Un
%   snrseg_meanLeft_Un
%   snrseg_meanRight_Un 
%   Pesq_scores_1chan   
%   SrmrCi_scores_1chan 
%   Stoi_scores_1chan   
%   snr_mean_1chan      
%   snrseg_mean_1chan   
%   NCM_scores_1chan
%   NCM_scores_Un
%   snr_front_left 
%   snr_front_right
% Input
%   ComputeAudios(Gain, Method, List, Noise)
%   Gain       -       'Wiener' / 'MMSE' / 'BMsk'
%   Method     -       'npsd_rs' / 'unbiased_mmse'
%   path       -       '1' / '2' / '3' / ... / 10;
%   Noise      -       'ICRA' / 'babble' / 'SSN_IEEE' 
%   DIROUT     -       
%   DIRSPEECH  -       
%   DIRHRIR    -       
%   DIRNOISE   -       
%   NAMESPEECH -   
%   FlagBinauMono
%   SNREstAl   -      'Cappe' / 'TSNR' / 'HRNR'
%   earref     -      1: left / 4: right
%   SNR        -      SNR vector (in reference ear)
%   AZN        -      noise azimuth ([ -180 : 5 : 180 ])

% output filenames---------------------------------------------------------
NAMOUT_A  = 'Z-BinauralData_A.mat';   % data output file name
NAMOUT_B  = 'Z-BinauralData_B.mat';   % data output file name
NAMOUT_C  = 'Z-BinauralData_C.mat';   % data output file name

% input filenames----------------------------------------------------------
NAMIN_B   = NAMOUT_A;                 % data input filename
NAMIN_C   = NAMOUT_B;                 % data input filename

% % info parameters----------------------------------------------------------
log   = 1;      % screen information ( 1 - on, 0 - off )
plots = 0;      % plot information   ( 1 - on, 0 - off )
info  = struct( 'log', log, 'plots', plots ); % structure to control info

% speech parameters--------------------------------------------------------
DTS = 300;              % speech distance  = [ 80 300 ]
ELS = 0;                % speech elevation = [ down -10 0 10 20 up ]
AZS = 0;                % speech azimuth   = { left -180 : 5 : 180 right }
sp_paramt = struct( 'DTS', DTS, 'ELS', ELS, 'AZS', AZS, 'NAMESPEECH', NAMESPEECH );

% noise parameters---------------------------------------------------------
TPN =    1;     % noise type       = [ 1 (file) 2 (low-pass) 3 (sine) 4 (white noise) ]
DTN =  300;     % noise distance   = [ 80 300 ]
ELN =    0;     % noise elevation  = [ -10 0 10 20 ]

if strcmp('ICRA',Noise) == 1
    NOISECELL  = {'ICRA_No01_16kHz_118s.wav'};
elseif strcmp('babble',Noise) == 1
    NOISECELL  = {'cafeteria_babble.wav'};
elseif strcmp('SSN_IEEE',Noise) == 1
    NOISECELL  = {'SSN_IEEE.wav'};
else
    disp('Options: ICRA / babble / SSN_IEEE');
end


%% Initialize variables
Pesq_scoresLeft     = zeros(size(SNR,2),size(AZS,2));
Pesq_scoresRight    = zeros(size(SNR,2),size(AZS,2));
SrmrCi_scores       = zeros(size(SNR,2),size(AZS,2));
SrmrCi_scores_clean = zeros(size(SNR,2),size(AZS,2));
Stoi_scoresLeft     = zeros(size(SNR,2),size(AZS,2));
Stoi_scoresRight    = zeros(size(SNR,2),size(AZS,2));
snr_meanLeft        = zeros(size(SNR,2),size(AZS,2));
snr_meanRight       = zeros(size(SNR,2),size(AZS,2));
Pesq_scoresLeft_Un  = zeros(size(SNR,2),size(AZS,2));
Pesq_scoresRight_Un = zeros(size(SNR,2),size(AZS,2));
SrmrCi_scores_Un    = zeros(size(SNR,2),size(AZS,2));
Stoi_scoresLeft_Un  = zeros(size(SNR,2),size(AZS,2));
Stoi_scoresRight_Un = zeros(size(SNR,2),size(AZS,2));
snr_meanLeft_Un     = zeros(size(SNR,2),size(AZS,2));
snr_meanRight_Un    = zeros(size(SNR,2),size(AZS,2));
snrseg_meanLeft     = zeros(size(SNR,2),size(AZS,2));
snrseg_meanRight    = zeros(size(SNR,2),size(AZS,2));
snrseg_meanLeft_Un  = zeros(size(SNR,2),size(AZS,2));
snrseg_meanRight_Un = zeros(size(SNR,2),size(AZS,2));
Pesq_scores_1chan   = zeros(size(SNR,2),size(AZS,2));
SrmrCi_scores_1chan = zeros(size(SNR,2),size(AZS,2));
Stoi_scores_1chan   = zeros(size(SNR,2),size(AZS,2));
NCM_scores_1chan    = zeros(size(SNR,2),size(AZS,2));
NCM_scores_Un       = zeros(size(SNR,2),size(AZS,2));
snr_mean_1chan      = zeros(size(SNR,2),size(AZS,2));
snrseg_mean_1chan   = zeros(size(SNR,2),size(AZS,2));
snr_front_left      = zeros(size(SNR,2),size(AZS,2));
snr_front_right     = zeros(size(SNR,2),size(AZS,2));

%%
   
    % NAMENOISE = NOISECELL{1,noise};
    NAMENOISE = NOISECELL{1,1};
    
    for angle = 1:length( AZN )         % for each angle    
        
        for snr_i = 1:length(SNR)       % for each SNR
            
            % Definition of dB
            dB = SNR(snr_i);
            disp(['SNR Fontes = ',num2str(dB)])
            
            % Name of output file (unprocessed)
            nameOutFile = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN(angle)),...
                '_SNR',string(dB),'_Un','.wav');            
            
            % save('ACG_data'); % save all variables of this script to use in next iteration
            no_paramt = struct( 'TPN', TPN, 'DTN', DTN, 'ELN', ELN, ...
                'AZN', AZN( angle ), 'SNR', dB, 'NAMENOISE', ...
                NAMENOISE ); % parameter AZN not defined = NaN
            
            % Generates Speech
            Binaural_A_SpeechGenerator2( DIROUT, DIRHRIR, DIRSPEECH, ...
                NAMOUT_A, sp_paramt, no_paramt, info );
            
            % Generates binaural signal (noisy signal, speech and noise)
            [Signal, speech, noiseAdj, snr_front_left(snr_i,angle), ...
                snr_front_right(snr_i,angle)] = ...
                Binaural_B_SignalGenerator2( DIROUT, DIRHRIR, DIRNOISE, ...
                NAMIN_B, NAMOUT_B, no_paramt, sp_paramt, info, earref );
            
            
            
            %% Get signals from left and right channels, considering 
            % in front mic.

            % Avoid overflow (x 0.3)
            Signal = 0.3.*Signal;
            speech = 0.3.*speech;
            noiseAdj = 0.3.*noiseAdj;
            
            FnamSpeech = strcat( DIRSPEECH, sp_paramt.NAMESPEECH, '.wav' );
            audioInformations = audioinfo(FnamSpeech);
            
            audiowrite(char(nameOutFile),Signal,16000,...
                'Title',audioInformations.Title);
            
            if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain)) == 1
                
                % Name of output file (processed)
                nameOutFileFilt = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN(angle)),...
                    '_SNR',string(dB),'_',Gain,'.wav');                
                
                if (FlagBinauMono == 2)
                    
                    Signal = [Signal(:,1) Signal(:,4)];
                    speech = [speech(:,1) speech(:,4)];
                    noiseAdj = [noiseAdj(:,1) noiseAdj(:,4)];
                    
                    % ------------------------------- 2 channels--------------
                    % Case using 'MMSE' or 'Wiener'
                    [~, ~, ~, ~, ~, ~, ~, Filter_Sig] = ...
                        ics_constr_rule_twoChannels(Signal, speech,...
                        noiseAdj, FSnew, char(nameOutFileFilt), Gain, Method);            

                    % Storage filter signal
%                     audiowrite(char(nameOutFileFilt), Filter_Sig, FSnew, ...
%                         'Title',audioInformations.Title);

                    % Align signals
                    [~,~,speech,Filter_Sig_Align] = sigalign(Filter_Sig, speech(:,earref));
                    
                    % Evalate in terms of SRMR_CI
                    [SrmrCi_scores(snr_i,angle), ~] = ...
                        SRMR_CI(Filter_Sig_Align, FSnew);
                    [SrmrCi_scores_clean(snr_i,angle), ~] = ...
                        SRMR_CI(speech(:,1), FSnew);
                    SrmrCi_scores(snr_i,angle) = ...
                        SrmrCi_scores(snr_i,angle)/SrmrCi_scores_clean(snr_i,angle);
            
            
                    % Evaluate in terms of STOI (Left and Right)
                    sigClean = speech(:,1);
                    Stoi_scoresLeft(snr_i,angle) = ...
                    	stoi(sigClean, Filter_Sig_Align, FSnew);

%                     sigClean = speech(:,2);
%                     Stoi_scoresRight(snr_i,angle) = ...
%                     	stoi(sigClean, Filter_Sig_Align, FSnew);


%                     % Evalate in terms of PESQ (Left and Right)
%                     [Pesq_scoresLeft(snr_i,angle)] = pesq_s( speech(:,1),...
%                         FSnew, Filter_Sig_Align, FSnew);
%                     [Pesq_scoresRight(snr_i,angle)] = pesq_s( speech(:,2),...
%                         FSnew, Filter_Sig_Align, FSnew);
%     
%                     % Evaluate in terms of SNR
%                     [snr_meanLeft(snr_i,angle), ...
%                         snrseg_meanLeft(snr_i,angle)]  = ...
%                         comp_snr(speech(:,1), Filter_Sig_Align, FSnew);
%                     [snr_meanRight(snr_i,angle), ...
%                         snrseg_meanRight(snr_i,angle)] = ...
%                         comp_snr(speech(:,2), Filter_Sig_Align, FSnew);
                
                elseif (FlagBinauMono == 1)
                    
                    % ------------------------------- 1 channel --------------
                    % avoid overflow
                    [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
                       ics_constr_rule(Signal(:,earref), speech(:,earref),...
                       noiseAdj(:,earref), FSnew, char(nameOutFileFilt), Gain, Method, SNREstAl);            
                   
                    % Storage filter signal
                    audiowrite(char(nameOutFileFilt),Filter_Sig_1chan,FSnew, ...
                        'Title',audioInformations.Title);
                   
                    % Align signals
                    [~,~,speech, Filter_Sig_Align_1chan] = sigalign(Filter_Sig_1chan, speech(:,earref));                  
                    
                    % Evalate in terms of SRMR_CI
                    [SrmrCi_scores_1chan(snr_i,angle), ~] = ...
                        SRMR_CI(Filter_Sig_Align_1chan, FSnew);
                    [SrmrCi_scores_clean(snr_i,angle), ~] = ...
                        SRMR_CI(speech(:,1), FSnew);
                    SrmrCi_scores_1chan(snr_i,angle) = ...
                        SrmrCi_scores_1chan(snr_i,angle)/SrmrCi_scores_clean(snr_i,angle);
                
                
                    % Evaluate in terms of STOI and NCM (Left and Right)
                    sigClean = speech(:,1);
                    % STOI
                    Stoi_scores_1chan(snr_i,angle) = ...
                    	stoi(sigClean, Filter_Sig_Align_1chan, FSnew);
                    % NCM
                    NCM_scores_1chan(snr_i,angle) = ...
                    	NCM(sigClean, Filter_Sig_Align_1chan,FSnew);                   
                    
                
%                     % Evalate in terms of PESQ
%                     [Pesq_scores_1chan(snr_i,angle)] = pesq_s( speech(:,1),...
%                         FSnew, Filter_Sig_Align_1chan, FSnew);                
%                 
%                     % Evaluate in terms of SNR
%                     [snr_mean_1chan(snr_i,angle), ...
%                         snrseg_mean_1chan(snr_i,angle)]  = ...
%                         comp_snr(speech(:,1), Filter_Sig_Align_1chan, FSnew);
                end
                
                % ----------- unprocessed signals -----------                
                       
                % Evalate in terms of SRMR_CI
                [SrmrCi_scores_Un(snr_i,angle), ~] = ...
                    SRMR_CI(Signal(:,earref), FSnew);
                [SrmrCi_scores_clean(snr_i,angle), ~] = ...
                    SRMR_CI(speech(:,1), FSnew);
                SrmrCi_scores_Un(snr_i,angle) = ...
                    SrmrCi_scores_Un(snr_i,angle)/SrmrCi_scores_clean(snr_i,angle);
                
            
                % Evaluate in terms of STOI and NCM (Left and Right)
                sigClean = Signal(:,earref);
                % Align signals
                [~,~,speech, sigClean] = sigalign(sigClean, speech(:,1));                  

                % STOI
                Stoi_scoresLeft_Un(snr_i,angle) = ...
                	stoi(speech(:,1), sigClean, FSnew);
                % NCM
                NCM_scores_Un(snr_i,angle) = ...
                    NCM(speech(:,1), sigClean, FSnew);
%                 else
%                     % STOI
%                     Stoi_scoresLeft_Un(snr_i,angle) = ...
%                         stoi(sigClean, speech(:,1), FSnew);
%                     %NCM
%                     NCM_scores_Un(snr_i,angle) = NCM(sigClean, speech(:,1),FSnew);
%                 end
%                 sigClean = Signal(:,2);
%                 if size(Signal(:,2),1) > size(speech(:,2),1)
%                     Stoi_scoresRight_Un(snr_i,angle) = ...
%                         stoi(sigClean(1:size(speech(:,2),1)), ...
%                         speech(:,2), FSnew);
%                 else
%                     Stoi_scoresRight_Un(snr_i,angle) = ...
%                         stoi(sigClean, ...
%                         speech(:,2), FSnew);
%                 end

                % Evalate in terms of PESQ (Left and Right)
%                 [Pesq_scoresLeft_Un(snr_i,angle)] = pesq_s( Signal(:,1),...
%                     FSnew, speech(:,1), FSnew);
%                 [Pesq_scoresRight_Un(snr_i,angle)] = pesq_s( Signal(:,2),...
%                     FSnew, speech(:,2), FSnew);
                
                
                % Evaluate in terms of SNR
%                 [snr_meanLeft_Un(snr_i,angle), ...
%                     snrseg_meanLeft_Un(snr_i,angle)]  = ...
%                     comp_snr(Signal(:,1), speech(:,1), FSnew);
%                 [snr_meanRight_Un(snr_i,angle), ...
%                     snrseg_meanRight_Un(snr_i,angle)] = ...
%                     comp_snr(Signal(:,2), speech(:,2), FSnew);


                
            elseif strcmp('BMsk',Gain) == 1
                
                % Name of output file (processed)
                nameOutFileFilt = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN(angle)),...
                    '_SNR',string(dB),'_',Gain,'.wav');                
                
                if (FlagBinauMono == 2)

                    Signal = [Signal(:,1) Signal(:,4)];
                    speech = [speech(:,1) speech(:,4)];
                    noiseAdj = [noiseAdj(:,1) noiseAdj(:,4)];

                    %-------------------------- 2 channels --------------------
                    % Case using 'BMsk'
                    [Filter_Sig] = ...
                        ics_twoChannels(Signal, speech,...
                        noiseAdj, FSnew, char(nameOutFileFilt), 0, Method);
                    
                    % Storage filter signal
%                     audiowrite(char(nameOutFileFilt), Filter_Sig, FSnew, ...
%                         'Title',audioInformations.Title);
                    
                    % Align signals
                    [~,~,speech, Filter_Sig_Align] = sigalign(Filter_Sig, speech(:,earref));
                                       
                    % Evalate in terms of SRMR_CI
                    [SrmrCi_scores(snr_i,angle), ~] = ...
                        SRMR_CI(Filter_Sig_Align, FSnew);
                    [SrmrCi_scores_clean(snr_i,angle), ~] = ...
                        SRMR_CI(speech(:,1), FSnew);
                    SrmrCi_scores(snr_i,angle) = ...
                        SrmrCi_scores(snr_i,angle)/SrmrCi_scores_clean(snr_i,angle);
                
            
            
                    % Evaluate in terms of STOI (Left and Right)
                    sigClean = speech(:,earref);
                    Stoi_scoresLeft(snr_i,angle) = ...
                    	stoi(sigClean, Filter_Sig_Align, FSnew);
                    
%                     sigClean = speech(:,2);
%                     Stoi_scoresRight(snr_i,angle) = ...
%                     	stoi(sigClean, Filter_Sig_Align, FSnew);

                
%                     % Evalate in terms of PESQ (Left and Right)
%                     [Pesq_scoresLeft(snr_i,angle)] = pesq_s( speech(:,1),...
%                     FSnew, Filter_Sig_Align, FSnew);
%                     [Pesq_scoresRight(snr_i,angle)] = pesq_s( speech(:,2),...
%                         FSnew, Filter_Sig_Align, FSnew);                
% 
%                     % Evaluate in terms of SNR
%                     [snr_meanLeft(snr_i,angle), ...
%                         snrseg_meanLeft(snr_i,angle)]  = ...
%                         comp_snr(speech(:,1), Filter_Sig_Align, FSnew);
%                     [snr_meanRight(snr_i,angle), ...
%                         snrseg_meanRight(snr_i,angle)] = ...
%                         comp_snr(speech(:,2), Filter_Sig_Align, FSnew);
                
                elseif (FlagBinauMono == 1)
                    
                   % ------------------------------- 1 channel --------------

                    % avoid overflow
                    [Filter_Sig_1chan] = ...
                       ics(Signal(:,1), speech(:,earref),...
                       noiseAdj(:,earref), FSnew, char(nameOutFileFilt), 0, Method);            

                    % Storage filter signal
                    audiowrite(char(nameOutFileFilt), Filter_Sig_1chan, FSnew, ...
                        'Title',audioInformations.Title);
                   
                    % Align signals
                    [~,~,speech, Filter_Sig_Align_1chan] = sigalign(Filter_Sig_1chan, speech(:,earref));
                                       
                    % Evalate in terms of SRMR_CI
                    [SrmrCi_scores_1chan(snr_i,angle), ~] = ...
                        SRMR_CI(Filter_Sig_Align_1chan, FSnew);                
                    [SrmrCi_scores_clean(snr_i,angle), ~] = ...
                        SRMR_CI(speech(:,1), FSnew);
                    SrmrCi_scores_1chan(snr_i,angle) = ...
                        SrmrCi_scores_1chan(snr_i,angle)/SrmrCi_scores_clean(snr_i,angle);
                
                
                    % Evaluate in terms of STOI and NCM (Left and Right)
                    sigClean = speech(:,1);
                    % STOI
                    Stoi_scores_1chan(snr_i,angle) = ...
                    	stoi(sigClean, Filter_Sig_Align_1chan, FSnew);
                    % NCM
                    NCM_scores_1chan(snr_i,angle) = ...
                    	NCM(sigClean, Filter_Sig_Align_1chan,FSnew);
                
%                     % Evalate in terms of PESQ
%                     [Pesq_scores_1chan(snr_i,angle)] = pesq_s( speech(:,1),...
%                         FSnew, Filter_Sig_Align_1chan, FSnew);                
%                 
%                     % Evaluate in terms of SNR
%                     [snr_mean_1chan(snr_i,angle), ...
%                         snrseg_mean_1chan(snr_i,angle)]  = ...
%                         comp_snr(speech(:,1), Filter_Sig_Align_1chan, FSnew);
                end
            else

                disp('Algoritmos possíveis: Wiener / MMSE / BMsk');
            end
            
        end        
    end


end