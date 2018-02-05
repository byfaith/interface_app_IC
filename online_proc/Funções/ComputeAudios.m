function ComputeAudios(Gain, Method, List, Noise, SNREstAl)
% ComputeAudios(Gain, Method, List, Noise, SNREstAl)
% Gain = 'Wiener' / 'MMSE' / 'BMsk'
% Method = 'npsd_rs' / 'unbiased_mmse' / 'Unprocessed'
% List = '1' / '2' / '3' / ... / 10;
% Noise = 'ICRA' / 'babble' 
% SNREstAl = 'Cappe' / 'TSNR' / 'HRNR'


%% Get set of voices

% Number of signals
NS = 10;

% Sampling frequency
FSnew = 16000;

% Path of voice files
% path = 'Databases\PortugueseSentences\Pasta01 - Traffic\F05170';
path1 = 'Databases\PortugueseSentences\Alcaim1\F0001\F00010';
path2 = 'Databases\PortugueseSentences\Alcaim1\F0002\F00020';
path3 = 'Databases\PortugueseSentences\Alcaim1\F0003\F00030';
path4 = 'Databases\PortugueseSentences\Alcaim1\F0004\F00040';
path5 = 'Databases\PortugueseSentences\Alcaim1\F0005\F00050';
path6 = 'Databases\PortugueseSentences\Alcaim1\F0006\F00060';
path7 = 'Databases\PortugueseSentences\Alcaim1\F0007\F00070';
path8 = 'Databases\PortugueseSentences\Alcaim1\F0008\F00080';
path9 = 'Databases\PortugueseSentences\Alcaim1\F0009\F00090';
path10 = 'Databases\PortugueseSentences\Alcaim1\F0010\F00100';

path11 = 'Databases\PortugueseSentences\Alcaim1\M0001\M00010';
path12 = 'Databases\PortugueseSentences\Alcaim1\M0002\M00020';
path13 = 'Databases\PortugueseSentences\Alcaim1\M0003\M00030';
path14 = 'Databases\PortugueseSentences\Alcaim1\M0004\M00040';
path15 = 'Databases\PortugueseSentences\Alcaim1\M0005\M00050';
path16 = 'Databases\PortugueseSentences\Alcaim1\M0006\M00060';
path17 = 'Databases\PortugueseSentences\Alcaim1\M0007\M00070';
path18 = 'Databases\PortugueseSentences\Alcaim1\M0008\M00080';
path19 = 'Databases\PortugueseSentences\Alcaim1\M0009\M00090';
path20 = 'Databases\PortugueseSentences\Alcaim1\M0010\M00100';



%% Alocate set of data (voices sampled at FSnew rate)
if strcmp(List,'1')
    [voice,FS,nbitsSig] = GetVoices(path1,NS);
elseif strcmp(List,'2')
    [voice,FS,nbitsSig] = GetVoices(path2,NS);
elseif strcmp(List,'3')
    [voice,FS,nbitsSig] = GetVoices(path3,NS);
elseif strcmp(List,'4')
    [voice,FS,nbitsSig] = GetVoices(path4,NS);
elseif strcmp(List,'5')
    [voice,FS,nbitsSig] = GetVoices(path5,NS);    
elseif strcmp(List,'6')
    [voice,FS,nbitsSig] = GetVoices(path6,NS);    
elseif strcmp(List,'7')
    [voice,FS,nbitsSig] = GetVoices(path7,NS);    
elseif strcmp(List,'8')
    [voice,FS,nbitsSig] = GetVoices(path8,NS);    
elseif strcmp(List,'9')
    [voice,FS,nbitsSig] = GetVoices(path9,NS);    
elseif strcmp(List,'10')
    [voice,FS,nbitsSig] = GetVoices(path10,NS);    
elseif strcmp(List,'11')
    [voice,FS,nbitsSig] = GetVoices(path11,NS);    
elseif strcmp(List,'12')
    [voice,FS,nbitsSig] = GetVoices(path12,NS);    
elseif strcmp(List,'13')
    [voice,FS,nbitsSig] = GetVoices(path13,NS);    
elseif strcmp(List,'14')
    [voice,FS,nbitsSig] = GetVoices(path14,NS);    
elseif strcmp(List,'15')
    [voice,FS,nbitsSig] = GetVoices(path15,NS);    
elseif strcmp(List,'16')
    [voice,FS,nbitsSig] = GetVoices(path16,NS);    
elseif strcmp(List,'17')
    [voice,FS,nbitsSig] = GetVoices(path17,NS);    
elseif strcmp(List,'18')
    [voice,FS,nbitsSig] = GetVoices(path18,NS);    
elseif strcmp(List,'19')
    [voice,FS,nbitsSig] = GetVoices(path19,NS);    
elseif strcmp(List,'20')
    [voice,FS,nbitsSig] = GetVoices(path20,NS);    
else
    disp('List not found!')
end
    


%% Get set of noises (babble and white sampled at FSnew rate)

if strcmp(Noise,'ICRA')
    [babble,fs_babble]=audioread('Databases\Noise Recordings\ICRA_No01_16kHz_118s.wav');
    info = audioinfo('Databases\Noise Recordings\ICRA_No01_16kHz_21s.wav');    
elseif strcmp(Noise,'babble')
    [babble,fs_babble]=audioread('Databases\Noise Recordings\cafeteria_babble.wav');
    info = audioinfo('Databases\Noise Recordings\cafeteria_babble.wav');    
elseif strcmp(Noise,'SSN_IEEE')
    [babble,fs_babble]=audioread('Databases\Noise Recordings\SSN_IEEE.wav');
    info = audioinfo('Databases\Noise Recordings\SSN_IEEE.wav');    
else
    disp('Options: ICRA / babble / SSN_IEEE')
end

nbits_noise = info.BitsPerSample;

% split signal into 5 segments(Cut signal in multiple of 5)
% segments
n = 5;
babble = babble(201:end-(mod(length(babble),n)),1);

% Define vector of noise signal (5 segments)
S = zeros(floor(size(babble,1)/5),n);          % First noise
S = reshape(babble,[],n);
clear babble

%% Add noise signal (each segment) to each voice signal, for each SNR

% SNR vector
VectorSNR = [-15 -10 -5 0 5 10 15 20]';
% VectorSNR = [20]';

% Cell used to storage signals
noisySpeechCity = cell(size(VectorSNR,1),n,NS);
SignalAdj = cell(size(VectorSNR,1),n,NS);
NoiseAdj = cell(size(VectorSNR,1),n,NS);

% Function that sum signal to noise at specific SNR level
[noisySpeechCity, SignalAdj, NoiseAdj] = Convert2Cell(NS,n,VectorSNR,...
    voice,fs_babble,nbitsSig,S,FS,FSnew);

% New sampling frequency of signals
fs_babbleNS = FSnew;

clear voice;
clear S;

%% Get filter signal by set of algorithm used
Pesq_scores = cell(size(VectorSNR,1),n,NS);
SrmrCi_scores = cell(size(VectorSNR,1),n,NS);
SrmrCi_scores_Clear = cell(size(VectorSNR,1),n,NS);
Stoi_scores = cell(size(VectorSNR,1),n,NS);

if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain)) == 1
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
            
                % avoid overflow
                [~, ~, ~, ~, ~, ~, ~, Filter_Sig] = ...
                   ics_constr_rule(0.5.*noisySpeechCity{p,q,r}, 0.5.*SignalAdj{p,q,r},...
                   0.5.*NoiseAdj{p,q,r}, FSnew, 'Fout', Gain, Method, SNREstAl);            

                % Align signals
                [~,~,~,Filter_Sig_Align] = sigalign(Filter_Sig,SignalAdj{p,q,r});%,maxd,m,fs);
                
                % Evalate in terms of PESQ
%                 [Pesq_scores{p,q,r}] = pesq_s( SignalAdj{p,q,r}, FSnew, ...
%                    Filter_Sig_Align, FSnew);
                       
                % Evalate in terms of SRMR_CI
                [SrmrCi_scores{p,q,r}, ~] = SRMR_CI(Filter_Sig_Align, FSnew);
            
            
%                 % Evaluate in terms of STOI
%                 sigClean = SignalAdj{p,q,r};
%                 if size(SignalAdj{p,q,r},1) > size(Filter_Sig_Align,1)
%                     Stoi_scores{p,q,r} = stoi(sigClean(1:size(Filter_Sig_Align,1)), Filter_Sig_Align, FSnew);
%                 else
%                     Stoi_scores{p,q,r} = stoi(SignalAdj{p,q,r}, Filter_Sig_Align(1:size(sigClean,1)), FSnew);
%                 end
            
            
            end
        end
        disp(['SNR = ',num2str(VectorSNR(p))])
    end
elseif strcmp('BMsk',Gain) == 1
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition   
                
                % avoid overflow
                [Filter_Sig] = ics(0.5.*noisySpeechCity{p,q,r}, ...
                    0.5.*SignalAdj{p,q,r}, 0.5.*NoiseAdj{p,q,r}, FSnew, ...
                    'Fout', 0, Method);
                
                % Align signals
                [~,~,~,Filter_Sig_Align] = sigalign(Filter_Sig,SignalAdj{p,q,r});%,maxd,m,fs);
            
                % Evalate in terms of PESQ
%                 [Pesq_scores{p,q,r}] = pesq_s( SignalAdj{p,q,r}, FSnew, ...
%                    Filter_Sig_Align, FSnew);
                       
                % Evalate in terms of SRMR_CI
                [SrmrCi_scores{p,q,r}, ~] = SRMR_CI(Filter_Sig_Align, FSnew);
            
            
                % Evaluate in terms of STOI
                sigClean = SignalAdj{p,q,r};
                if size(SignalAdj{p,q,r},1) > size(Filter_Sig_Align,1)
                    Stoi_scores{p,q,r} = stoi(sigClean(1:size(Filter_Sig_Align,1)), Filter_Sig_Align, FSnew);
                else
                    Stoi_scores{p,q,r} = stoi(SignalAdj{p,q,r}, Filter_Sig_Align(1:size(sigClean,1)), FSnew);
                end
                
            end
        end
    end                
elseif strcmp('Unprocessed',Gain) == 1
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
    
                %Unprocessed audios
                [Pesq_scores{p,q,r}] = pesq_s( SignalAdj{p,q,r}, FSnew, ...
                  noisySpeechCity{p,q,r}, FSnew);            
                [SrmrCi_scores{p,q,r}, ~] = ...
                    SRMR_CI(noisySpeechCity{p,q,r}, FSnew);
                
            end
        end
        disp(['SNR = ',num2str(VectorSNR(p))])
    end
elseif strcmp('Clean',Gain) == 1
    for p=1:length(VectorSNR)   % For each SNR
        for r=1:1:NS            % For each signal
            for q=1:1:n         % For each repetition
                
                % Clear audios
                [SrmrCi_scores_Clear{p,q,r}, ~] = ...
                    SRMR_CI(SignalAdj{p,q,r}, FSnew);
            end
        end
        disp(['SNR = ',num2str(VectorSNR(p))])
    end    
else
    disp('Algoritmos possíveis: Wiener / MMSE / BMsk');
end
clear noisySpeechCity
clear SignalAdj
clear NoiseAdj


%% Save variables
if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain) || strcmp('BMsk',Gain)) == 1
    nameFile = strcat(Gain,'_',Method,'_List',List,'_',Noise);
    %save(strcat(nameFile,'.mat'), 'Pesq_scores', 'SrmrCi_scores', 'Stoi_scores')
    save(strcat(nameFile,'.mat'), 'Pesq_scores', 'SrmrCi_scores')
end
%% Save unprocessed audios
if strcmp('Unprocessed',Gain) == 1
    nameFile = strcat('_List',List,'_',Noise,'_','NaoProcessado');
    save(strcat(nameFile,'.mat'), 'Pesq_scores', 'SrmrCi_scores')
end

if strcmp('Clean',Gain) == 1
    nameFile = strcat('_List',List,'_',Noise,'_','Clear');
    save(strcat(nameFile,'.mat'), 'SrmrCi_scores_Clear')
end




end