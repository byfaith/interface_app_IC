function signal_out = sigproc(pathspeech, speech, noise, snr, Gain, earref, AZN, flagSaveWav)
% Create an acoustic scenario considering a speech and noise signal.
% Then apply signal processing technique to subtract background noise. All
% the processing signal is doing by considering 1 microphone
% input:
%   pathspeech:  path of speech file
%   speech:      clean voice signal 
%   noise:       name of noise file ('babble' / 'ICRA' / 'SSN_IEEE')
%   snr:         SNR [dB]
%   Gain:        algorithm of noise reduction ('Wiener' / 'MMSE' / 'BMsk / Un')
%   earref:      reference ear (ear that has CI) - (1: left / 4: right)
%   AZN:         noise azimuth - [ -180 : 5 : 180 ] (speech in front!)
%   flagSaveWav: enable (1)or disable (0) to save .wav audio files
% output: 
%   signal_out:  processed signal, per channel

% directory definitions ---------------------------------------------------
DIROUT    = './Results/';            % output file directory
DIRHRIR   = './Data/Hrir/';          % hrir file directory
DIRNOISE  = './Data/Noise/';         % noise  file directory

% NAMESPEECH = 'F0001001';
% DIRSPEECH = 'C:\Users\Gustavo\Documents\MasterUFSC_2\EstimadoresSNR\';        % input speech file directory
NAMESPEECH = speech;
DIRSPEECH = pathspeech;

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

%% Background noise type
% Noise = 'babble';

if strcmp('ICRA',noise) == 1
    NOISECELL  = {'ICRA_No01_16kHz_118s.wav'};
elseif strcmp('babble',noise) == 1
    NOISECELL  = {'cafeteria_babble.wav'};
elseif strcmp('SSN_IEEE',noise) == 1
    NOISECELL  = {'SSN_IEEE.wav'};
else
    disp('Options: ICRA / babble / SSN_IEEE');
end
NAMENOISE = NOISECELL{1,1};

%% Definition of dB
dB = snr;

%% considering that all the are signals already at 16KHz
FSnew = 16000;

%% Method of noise estimation (npsd_rs)
Method = 'npsd_rs';

%% Algorithm of SNR estimation
SNREstAl = 'Cappe';


% Name of output file (unprocessed)
nameOutFile = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN),...
	'_SNR',string(dB),'_Un','.wav');            
            
% save('ACG_data'); % save all variables of this script to use in next iteration
no_paramt = struct( 'TPN', TPN, 'DTN', DTN, 'ELN', ELN, ...
	'AZN', AZN, 'SNR', dB, 'NAMENOISE', ...
    NAMENOISE ); % parameter AZN not defined = NaN
  
% Generates Speech
Binaural_A_SpeechGenerator2( DIROUT, DIRHRIR, DIRSPEECH, ...
	NAMOUT_A, sp_paramt, no_paramt, info );

% Generates binaural signal (noisy signal, speech and noise)
[Signal, speech, noiseAdj, snr_front_left, ...
	snr_front_right] = ...
    Binaural_B_SignalGenerator2( DIROUT, DIRHRIR, DIRNOISE, ...
    NAMIN_B, NAMOUT_B, no_paramt, sp_paramt, info, earref );

% Avoid overflow (x 0.3)
Signal = 0.3.*[Signal(:,1) Signal(:,4)];
speech = 0.3.*[speech(:,1) speech(:,4)];
noiseAdj = 0.3.*[noiseAdj(:,1) noiseAdj(:,4)];
            
FnamSpeech = strcat( DIRSPEECH, sp_paramt.NAMESPEECH, '.wav' );
audioInformations = audioinfo(FnamSpeech);


if (strcmp('Wiener',Gain) || strcmp('MMSE',Gain)) == 1
                
	% Name of output file (processed)
    nameOutFileFilt = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN),...
    	'_SNR',string(dB),'_',Gain,'.wav');                
    
    % Filter left signal
	[~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan_left] = ...
    	ics_constr_rule(Signal(:,1), speech(:,1),...
        noiseAdj(:,1), FSnew, char(nameOutFileFilt), Gain, Method, SNREstAl);            
    
    % Filter right signal
	[~, ~, ~, ~, ~, ~, ~, Filter_Sig_1chan_right] = ...
    	ics_constr_rule(Signal(:,2), speech(:,2),...
        noiseAdj(:,2), FSnew, char(nameOutFileFilt), Gain, Method, SNREstAl);            
    
elseif strcmp('Binary Mask',Gain) == 1
    
	% Name of output file (processed)
    nameOutFileFilt = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN),...
    	'_SNR',string(dB),'_',Gain,'.wav');                
    
    % Filter right signal
	[Filter_Sig_1chan_left] = ...
    	ics(Signal(:,1), speech(:,1),...
        noiseAdj(:,1), FSnew, char(nameOutFileFilt), 0, Method);            
    
    % Filter right signal
	[Filter_Sig_1chan_right] = ...
    	ics(Signal(:,2), speech(:,2),...
        noiseAdj(:,2), FSnew, char(nameOutFileFilt), 0, Method);       
   
elseif strcmp('Unprocessed',Gain) == 1
    
	% Name of output file (processed)
    nameOutFileFilt = strcat(DIROUT, NAMESPEECH,'_S0N',string(AZN),...
    	'_SNR',string(dB),'_',Gain,'.wav');     
    
    Filter_Sig_1chan_left = Signal(:,1);
    Filter_Sig_1chan_right = Signal(:,2);
    
else
    
    disp('Algoritmos possíveis: Wiener / MMSE / BMsk');    
    
end

signal_out = [Filter_Sig_1chan_left Filter_Sig_1chan_right];

if flagSaveWav == 1
    
    % Storage audio file
	audiowrite(char(nameOutFile),Signal,16000,...
    	'Title',audioInformations.Title);
    
    % Storage filter signal    
    audiowrite(char(nameOutFileFilt), signal_out, FSnew, ...
        'Title',audioInformations.Title);

end