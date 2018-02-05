function [SrmrCi_scores_Std, SrmrCi_scores_StdClean, SrmrCi_scores_StdAlc, SrmrCi_scores_StdCleanAlc] = GetSRMRStd(snr, pathFilesC, Gain, Method, SNREstAl)
% function [SrmrCi_scores_Std, SrmrCi_scores_StdClean, SrmrCi_scores_StdAlc, SrmrCi_scores_StdCleanAlc] = GetSRMRStd(snr, pathFilesC, Gain, Method)
% SrmrCi_scores_Std:            SRMR-CI value from corruped signal (Santos)
% SrmrCi_scores_StdClean:       SRMR-CI value from clean signal (Santos)
% SrmrCi_scores_StdAlc:         SRMR-CI value from corruped signal (Alcaim)
% SrmrCi_scores_StdCleanAlc:    SRMR-CI value from clean signal (Alcaim)
% snr:                      snr required
% pathFilesC:               path of clear files
% Gain:                     'Wiener' / 'MMSE' / 'BMsk' / 'Un'
% Method:                   'npsd_rs' / 'unbiased_mmse'
% SNREstAl:                 'Cappe' / 'TSNR' / 'HRNR'
% Return values from metric SRMR-CI related to standard database(Santos, J)


% Noise
noise = 'babble';

if strcmp('ICRA',noise) == 1
    [icra,~]=audioread('Databases\Noise Recordings\ICRA_No01_16kHz_118s.wav');
    info = audioinfo('Databases\Noise Recordings\ICRA_No01_16kHz_118s.wav');
elseif strcmp('babble',noise) == 1
    [icra,~]=audioread('Databases\Noise Recordings\cafeteria_babble.wav');
    info = audioinfo('Databases\Noise Recordings\cafeteria_babble.wav');
elseif strcmp('SSN_IEEE',noise) == 1
    [icra,~]=audioread('Databases\Noise Recordings\SSN_IEEE.wav');
    info = audioinfo('Databases\Noise Recordings\SSN_IEEE.wav');
else
    disp('Options: ICRA / babble / SSN_IEEE');
end
icra = mean(icra,2);

% Bits
nbits_noise = info.BitsPerSample;


% Names of Alcaim database
path = {'F0001' 'F0002' 'F0003' 'F0004' 'F0005' 'F0006' 'F0007' 'F0008' 'F0009'...
    'F0010' 'M0001' 'M0002' 'M0003' 'M0004' 'M0005' 'M0006' 'M0007'...
    'M0008' 'M0009' 'M0010'};
% path = {'M0002'};

% Number of signals get from Alcaim database
NS = 10;

voice = [];
fs = [];
SrmrCi_scores_StdAlc = zeros(NS,size(path,2));
SrmrCi_scores_StdCleanAlc = zeros(NS,size(path,2));


% ---------- Alcaim ------------

for p=1:size(path,2)
	for l=1:1:NS
        if l < 10 %&& k ~= 7 && k ~= 8 && k ~= 9 && k ~= 10
        
        	path_pass = strcat(path(p),'00');
            NAMESPEECH = strcat(path_pass,num2str(l));                    
            DIRSPEECH = strcat('Databases/PortugueseSentences/Alcaim1/',...
            	char(path(p)),'/');        % input speech file directory

            nameFile = char(strcat(DIRSPEECH,NAMESPEECH,'.wav'));
            
            [voiceClean,fs] = audioread(nameFile);
            voiceClean = 0.3*voiceClean;
            
            % Corrupt signal with 'ICRA' noise
            icranoise = 0.3.*icra(200:length(voiceClean)+200-1);
            
            
            [voice, voiceClean, icranoise] = s_and_n(voiceClean,icranoise,snr);
            
            
            if strcmp('Wiener',Gain) == 1
        
                [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
                	ics_constr_rule(voice, voiceClean,...
                    icranoise, fs, 'Fout', Gain, Method, SNREstAl);
        
                % Align signals
                [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);        
                     
                        
            elseif strcmp('MMSE',Gain) == 1
        
                [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
                	ics_constr_rule(voice, voiceClean,...
                    icranoise, fs, 'Fout', Gain, Method, SNREstAl);

                % Align signals
                [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);        
                       
        
            elseif strcmp('BMsk',Gain) == 1
        
                [Filter_Sig_1chan] = ...
                	ics(voice, voiceClean,...
                    icranoise, fs, 'Fout', 0, Method);

                % Align signals
                [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);        
                        
        
            elseif strcmp('Un',Gain) == 1
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);
                        
                
            else
                disp('Algoritmos possíveis: Wiener / MMSE / BMsk');
            end
    
            disp(['File Alcaim:: ', NAMESPEECH])
            
            
            
            
        else
                    
        	path_pass = [];
            path_pass = strcat(path(p),'0');
            NAMESPEECH = strcat(path_pass,num2str(l));
            DIRSPEECH = strcat('Databases\PortugueseSentences\Alcaim1\',...
            	char(path(p)),'\');        % input speech file directory
            
            nameFile = char(strcat(DIRSPEECH,NAMESPEECH,'.wav'));
            
            [voiceClean,fs] = audioread(nameFile);
            voiceClean = 0.3*voiceClean;
            
            % Corrupt signal with 'ICRA' noise
            icranoise = 0.3.*icra(200:length(voiceClean)+200-1);
            
            [voice, voiceClean, icranoise] = s_and_n(voiceClean,icranoise,snr);            
            
            
            if strcmp('Wiener',Gain) == 1
        
                [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
                	ics_constr_rule(voice, voiceClean,...
                    icranoise, fs, 'Fout', Gain, Method, SNREstAl);
        
                % Align signals
                [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);        
        
        
            elseif strcmp('MMSE',Gain) == 1
        
                [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
                	ics_constr_rule(voice, voiceClean,...
                    icranoise, fs, 'Fout', Gain, Method, SNREstAl);

                % Align signals
                [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);        
        
        
            elseif strcmp('BMsk',Gain) == 1
        
                [Filter_Sig_1chan] = ...
                	ics(voice, voiceClean,...
                    icranoise, fs, 'Fout', 0, Method);

                % Align signals
                [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);        
        
        
            elseif strcmp('Un',Gain) == 1
        
                % Get SRMR-CI from corrupted signal
                [SrmrCi_scores_StdAlc(l,p), ~] = SRMR_CI(voice, fs);
    
                % Get SRMR-CI from clean signal
                [SrmrCi_scores_StdCleanAlc(l,p), ~] = SRMR_CI(voiceClean, fs);
        
            else
                disp('Algoritmos possíveis: Wiener / MMSE / BMsk');
            end
    
            disp(['File Alcaim:: ', NAMESPEECH])
            
            
                    
        end
                
	end
end
        
% Transform set of data in line
cumVar = [];
for l=1:size(SrmrCi_scores_StdAlc,1)
    cumVar = [cumVar SrmrCi_scores_StdAlc(l,:)];
end
SrmrCi_scores_StdAlc = cumVar;


cumVarClean = [];
for l=1:size(SrmrCi_scores_StdCleanAlc,1)
    cumVarClean = [cumVarClean SrmrCi_scores_StdCleanAlc(l,:)];
end
SrmrCi_scores_StdCleanAlc = cumVarClean;

% ---------- Alcaim ------------









% Number of signals get from Santos, J. database
NS = 200;
% NS = 10;

voice = [];
fs = [];

SrmrCi_scores_Std = zeros(NS,1);
SrmrCi_scores_StdClean = zeros(NS,1);

% ---------- Santos ------------

for k=4:NS+3

    nameFile = strcat(pathFilesC(k).folder, '\', pathFilesC(k).name);
    
    [voiceClean,fs] = audioread(nameFile);
    voiceClean = 0.3*voiceClean;
    
    % Corrupt signal with 'ICRA' noise
    icranoise = 0.3.*icra(200:length(voiceClean)+200-1);
    voice = s_and_n(voiceClean,icranoise,snr);
    
    
	if strcmp('Wiener',Gain) == 1
        
        [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
        	ics_constr_rule(voice, voiceClean,...
            icranoise, fs, 'Fout', Gain, Method, SNREstAl);
        
        % Align signals
        [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
        % Get SRMR-CI from corrupted signal
        [SrmrCi_scores_Std(k-3,1), ~] = SRMR_CI(voice, fs);
    
        % Get SRMR-CI from clean signal
        [SrmrCi_scores_StdClean(k-3,1), ~] = SRMR_CI(voiceClean, fs);        
        
        
    elseif strcmp('MMSE',Gain) == 1
        
        [~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan] = ...
        	ics_constr_rule(voice, voiceClean,...
            icranoise, fs, 'Fout', Gain, Method, SNREstAl);

        % Align signals
        [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
        % Get SRMR-CI from corrupted signal
        [SrmrCi_scores_Std(k-3,1), ~] = SRMR_CI(voice, fs);
    
        % Get SRMR-CI from clean signal
        [SrmrCi_scores_StdClean(k-3,1), ~] = SRMR_CI(voiceClean, fs);        
        
        
    elseif strcmp('BMsk',Gain) == 1
        
        [Filter_Sig_1chan] = ...
        	ics(voice, voiceClean,...
            icranoise, fs, 'Fout', 0, Method);

        % Align signals
        [~,~,voiceClean, voice] = sigalign(Filter_Sig_1chan, voiceClean);
        
        % Get SRMR-CI from corrupted signal
        [SrmrCi_scores_Std(k-3,1), ~] = SRMR_CI(voice, fs);
    
        % Get SRMR-CI from clean signal
        [SrmrCi_scores_StdClean(k-3,1), ~] = SRMR_CI(voiceClean, fs);        
        
        
    elseif strcmp('Un',Gain) == 1
        
        % Get SRMR-CI from corrupted signal
        [SrmrCi_scores_Std(k-3,1), ~] = SRMR_CI(voice, fs);
    
        % Get SRMR-CI from clean signal
        [SrmrCi_scores_StdClean(k-3,1), ~] = SRMR_CI(voiceClean, fs);
        
    else
        disp('Algoritmos possíveis: Wiener / MMSE / BMsk');
	end
    
    
    
    disp(['File Santos:: ', pathFilesC(k).name])
    
end

% ---------- Santos ------------














%% -=-----------------------------------------------------
% voice = [];
% fs = [];
% SrmrCi_scores_Std = zeros(length(pathFiles),1);
% SrmrCi_scores_StdClean = zeros(length(pathFiles),1);
% for k=4:length(pathFiles)
%     nameFile = strcat(pathFiles(k).folder, '\', pathFiles(k).name);
%     [voice,fs] = audioread(nameFile);
%     
%     % Get SRMR-CI from corrupted signal
%     [SrmrCi_scores_Std(k,1), ~] = SRMR_CI(voice, fs);
%     
%     % Get SRMR-CI from clean signal
%     % --- Find on 'clean_16k' the clean speech ---
%     p = 1;
%     while strcmp(pathFiles(k).name(1:7),pathFilesC(p+2).name(1:7)) ~= 1
%         p = p+1;
%     end
%     disp(['File corrupted:: ', pathFiles(k).name(1:7)])
%     disp(['File clean:: ', pathFilesC(p+2).name(1:7)])
%     
%     nameFileClean = strcat(pathFilesC(p+2).folder, '\', pathFilesC(p+2).name);
%     [voiceCln, fs] = audioread(nameFileClean);
%     [SrmrCi_scores_StdClean(k,1), ~] = SRMR_CI(voiceCln, fs);
%     
% end
