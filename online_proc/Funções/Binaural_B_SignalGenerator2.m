% -------------------------------------------------------------------------
% Binaural_B_SignalGenerator.m
%
% Generates binaural signal (noise, speech and noisy signal).
%
% [1] H. Kayser, S.D. Ewert, J. Anemuller, T. Rohdenburg, V. Hohmann, B. 
% Kollmeier (2009) Database of multichannel in-ear and behind-the-ear
% head-related and binaural room impulse responses. EURASIP Journal on
% Advances in Signal Processing, pages 1-10.
%
% [2] IEEE (2010) IEEE Standard Methods for Measuring Transmission 
% Performance of Analog and Digital Telephone Sets, Handsets, and 
% Headsets. IEEE Std 269-2010 (Revision of IEEE Std 269-2002), pp 1-173. 
%
% Marcio Costa
% 01/07/2013
% -------------------------------------------------------------------------

% function [input_signal, speech, noise, snr_front_left, snr_front_right] = Binaural_B_SignalGenerator2( DIROUT, DIRHRIR, DIRNOISE, NAMIN, NAMOUT, no_paramt, sp_paramt, info )
function [input_signal, speech, noise, snr_front_left, snr_front_right] = Binaural_B_SignalGenerator2( DIROUT, DIRHRIR, DIRNOISE, NAMIN, NAMOUT, no_paramt, sp_paramt, info, earref )
if( info.log )
    disp( 'B: SIGNAL GENERATOR' );
end

% simulated noise ---------------------------------------------------------
FRQ =   2500;   % frequency of the simulated sinusoid (Hz)

% Low pass filter
FPN_LP =   3000;	% pass-band frequency (Hz)
FSN_LP =   4000;	% stop-band frequency (Hz)
RSN_LP =     20;	% stop-band minimum attenuation (dB)
RPN_LP =      3;   % pass-band maximum attenuation (dB)

% High pass filter
FPN_HP =   1500;	% pass-band frequency (Hz) 1500
FSN_HP =   1000;	% stop-band frequency (Hz) 1000
RSN_HP =     20;	% stop-band minimum attenuation (dB)
RPN_HP =      3;    % pass-band maximum attenuation (dB)

% ear to be calculated the SNR [ 0 (left) 1 (right) ]
if( no_paramt.AZN <= 0 )
    SNS = 0;
elseif( no_paramt.AZN > 0 )
    SNS = 1;
end
        
% normalization factor ----------------------------------------------------
FCT =   0.9;    % normalization factor (for wave recordings)

% output filenames --------------------------------------------------------
NAMINFRNT = 'A1-input_front.wav';     % front  input  microphone filename 
NAMINMIDD = 'A2-input_middle.wav';    % middle input  microphone filename
NAMINREAR = 'A3-input_rear.wav';      % rear   input  microphone filename
NAMSPFRNT = 'A4-speech_front.wav';    % front  speech microphone filename
NAMSPMIDD = 'A5-speech_middle.wav';   % middle speech microphone filename
NAMSPREAR = 'A6-speech_rear.wav';     % rear speech   microphone filename
NAMNOFRNT = 'A7-noise_front.wav';     % front noise   microphone filename
NAMNOMIDD = 'A8-noise_middle.wav';    % middle noise  microphone filename
NAMNOREAR = 'A9-noise_rear.wav';      % rear noise    microphone filename


% *************************************************************************
% Filenames
% *************************************************************************

FnamIn     = strcat(DIROUT,NAMIN); 
FnamNoise  = strcat(DIRNOISE,no_paramt.NAMENOISE);
FnamInFrnt = strcat(DIROUT,NAMINFRNT);
FnamSpOut  = strcat( DIROUT, sp_paramt.NAMESPEECH, '_DTS', ...
    num2str(sp_paramt.DTS), '_ELS', num2str(sp_paramt.ELS), ...
    '_AZS', num2str(sp_paramt.AZS), '_SNR', ...
    num2str(no_paramt.SNR), '-A1-input', '_front.wav' );
FnamInFrnt = FnamSpOut;
FnamInMidd = strcat(DIROUT,NAMINMIDD);
FnamInRear = strcat(DIROUT,NAMINREAR);
FnamSpFrnt = strcat(DIROUT,NAMSPFRNT);
FnamSpMidd = strcat(DIROUT,NAMSPMIDD);
FnamSpRear = strcat(DIROUT,NAMSPREAR);
FnamNoFrnt = strcat(DIROUT,NAMNOFRNT);
FnamNoMidd = strcat(DIROUT,NAMNOMIDD);
FnamNoRear = strcat(DIROUT,NAMNOREAR);
FnamOut    = strcat(DIROUT,NAMOUT);
% *************************************************************************
% Load input files
% *************************************************************************

% speech  -----------------------------------------------------------------
load(FnamIn);  

% HRIR [1] ----------------------------------------------------------------
old = cd;
cd(DIRHRIR)
hrir = Load_hrir('Anechoic',no_paramt.DTN,no_paramt.ELN,no_paramt.AZN,'bte'); % odd channel is left side
cd(old)
% HRIRNO = resample(hrir.data,FAM,48000);
HRIRNO = resample(hrir.data,FAM,16000);
clear old hrir;

% noise -------------------------------------------------------------------
tamsp_ori = tamsign + length(HRIRNO) - 1;

switch(no_paramt.TPN)
    
    % file ----------------------------------------------------------------
    case 1
        disp('   Noise Type: Noise obtained from external file');
        disp(['   Noise file: ', no_paramt.NAMENOISE]); 
        [noise_ori,fsori] = audioread(FnamNoise);
        tamno_ori = length(noise_ori);
        if ( (fsori~=FAM) || (tamno_ori<tamsp_ori) )
            disp('Different noise/speech sampling frequencies or lengths');
            pause;
        end
        noise_ori = noise_ori(1:tamsp_ori);        
        clear fsori tamno_ori;
        
    % low-pass noise ------------------------------------------------------
    case 2
        disp('  Noise Type: Low-pass artificial noise');
        no_paramt.NAMENOISE = 'Low_pass';
        ws        = 2 * FSN_LP / FAM;                  % stop-band frequency
        wp        = 2 * FPN_LP / FAM;                  % pass-band frequency
        [n,wn]    = buttord(wp,ws,RPN_LP,RSN_LP);         % filter order
        [b,a]     = butter(n,wn);                   % filter coeffients
        noise_ori = filter(b,a,randn(tamsp_ori,1)); % low-pass noise
        clear ws wp n wn b a;
        
    % sinusoid noise ------------------------------------------------------
    case 3
        disp('  Noise Type : Sinusoid artificial noise');
        noise_ori = sin(2*pi*FRQ/FAM*(1:tamsp_ori));
        no_paramt.NAMENOISE = 'Sinusoid';
    
    case 4
        disp('  Noise Type: Gaussian noise');
        noise_ori = randn(tamsp_ori,1);
        no_paramt.NAMENOISE = 'White_noise';
        
    case 5
        disp('   Noise Type: High-pass artificial noise');
        no_paramt.NAMENOISE = 'High_pass';
        ws        = 2 * FSN_HP / FAM;                    % stop-band frequency
        wp        = 2 * FPN_HP / FAM;                    % pass-band frequency
        [n,wn]    = buttord( wp, ws, RPN_HP, RSN_HP );   % filter order
        [b,a]     = butter( n, wn, 'high' );             % filter coeffients
        noise_ori = filter( b, a, randn(tamsp_ori,1) );  % low-pass noise
        
        load './Data/Noise/Highpass_ori_17s'
        clear ws wp n wn b a;
end
clear tamsp_ori tamno_ori;

%**************************************************************************
% Convolution with hrir
%**************************************************************************

% convolved noise ---------------------------------------------------------
noise_hri = zeros(tamsign,numchan);
for cont = 1 : numchan/2
        noise_hri(:,cont) = conv(noise_ori,HRIRNO(:,2*(cont-1)+1),'valid');
        noise_hri(:,cont+numchan/2) = conv(noise_ori,HRIRNO(:,2*cont),'valid');
end
clear cont noise_ori;
          
%**************************************************************************
% Signal to noise ratio
%**************************************************************************

% search for the initial nonzero vad sample -------------------------------
% flag  = 1;    
% cont1 = 0;   
% ini   = 0;
% while(flag)
%     cont1 = cont1 + 1;
%     if (speech_vad(cont1)>0)
%         ini  = cont1;
%         flag = 0;
%     end
% end
% clear flag cont1;
% 
% % search for the final nozero vad sample ----------------------------------
% flag  = 1;       
% cont1 = tamsign+1;  
% fim   = 0;
% while(flag)
%     cont1 = cont1 - 1;
%     if (speech_vad(cont1)>0)
%         fim  = cont1;
%         flag = 0;
%     end
% end
% clear flag cont1;
% 
% % epoch for SNR calculation -----------------------------------------------
% vad          = zeros(tamsign,1);
% vad(ini:fim) = 1;
% norma        = sum(vad);
% 
% if( SNS == 0 )
%     pot_speech = sum((speech_hri(:,1) .* vad).^2) / norma;
%     pot_noise  = sum((noise_hri(:,1)  .* vad).^2) / norma;
% else
%     pot_speech = sum((speech_hri(:,numchan/2+1) .* vad).^2) / norma;
%     pot_noise  = sum((noise_hri(:,numchan/2+1)  .* vad).^2) / norma;
% end
% 
% amp_noise = sqrt(pot_speech/pot_noise*(10^(-no_paramt.SNR/10)));
% noise_hri = amp_noise * noise_hri;
% 
% snr_front_left  = 10*log10( sum((speech_hri(:,1) .* vad).^2) / ...
%     sum((noise_hri(:,1) .* vad).^2) );
% 
% snr_front_right = 10*log10( sum((speech_hri(:,numchan/2+1).* vad).^2) / ...
%     sum((noise_hri(:,numchan/2+1) .* vad).^2) );

% snr_front_left  = 10*log10( sum((speech_hri(:,1)).^2) / ...
%     sum((noise_hri(:,1)).^2) );

%clear vad norma pot_speech pot_noise amp_noise;


%**************************************************************************
% Signals at the ears
%**************************************************************************
% input_signal = speech_hri  + noise_hri;

%% Use 's_and_n.m' to obtain Signal-to-noise ratio
[input_signal, speech_hri, noise_hri] = s_and_n_binaural(speech_hri, ...
    noise_hri, no_paramt.SNR, earref);

% Use Welch's method to measure SNR get at microphone
snr_front_left = 10*log10(sum(pwelch(speech_hri(:,1)))/...
    sum(pwelch(noise_hri(:,1))));

snr_front_right = 10*log10(sum(pwelch(speech_hri(:,numchan/2+1)))/...
    sum(pwelch(noise_hri(:,numchan/2+1))));


% Adjust SNR measure on reference mic.(left ear) by improve power at noise
% source


%%

norma = max( max( abs( [ input_signal noise_hri speech_hri ] ) ) );

input_signal = (FCT/norma) * input_signal;
speech       = (FCT/norma) * speech_hri;
noise        = (FCT/norma) * noise_hri;

clear norma;


%**************************************************************************
% Save binaural data
%**************************************************************************

% save(FnamOut,'no_paramt','sp_paramt','FAM','HRIRSP','DIRSPEECH',...
%     'DIRHRIR','speech_ori','speech_hri','speech_vad','tamsign', ...
%     'numchan','HRIRNO','FRQ','FPN_LP','FSN_LP','RSN_LP','RPN_LP',...
%     'FPN_HP','FSN_HP','RSN_HP','RPN_HP','FCT','input_signal','speech',...
%     'noise','snr_front_left','snr_front_right',...
%     'ini','fim');

save(FnamOut,'no_paramt','sp_paramt','FAM','HRIRSP','DIRSPEECH',...
    'DIRHRIR','speech_ori','speech_hri','tamsign', ...
    'numchan','HRIRNO','FRQ','FPN_LP','FSN_LP','RSN_LP','RPN_LP',...
    'FPN_HP','FSN_HP','RSN_HP','RPN_HP','FCT','input_signal','speech',...
    'noise');


cd ./Progs
% Pesq_in_left  = pesqbin(speech_hri(:,1),input_signal(:,1),FAM,'wb');
% Pesq_in_right = pesqbin(speech_hri(:,4),input_signal(:,4),FAM,'wb');
cd ..

%**************************************************************************
% Save waves
%**************************************************************************

% signal ------------------------------------------------------------------
%%%% ALTERATE NAME OF FILE SAVED (AFTER...)

% audiowrite(FnamInFrnt,[ input_signal(:,1) input_signal(:,4)],FAM);

% audiowrite(FnamInMidd,[ input_signal(:,2) input_signal(:,5)],FAM);
% audiowrite(FnamInRear,[ input_signal(:,3) input_signal(:,6)],FAM);

% speech ------------------------------------------------------------------
% audiowrite(FnamSpFrnt,[ speech(:,1) speech(:,4)],FAM);
% audiowrite(FnamSpMidd,[ speech(:,2) speech(:,5)],FAM);
% audiowrite(FnamSpRear,[ speech(:,3) speech(:,6)],FAM);

% noise -------------------------------------------------------------------
% audiowrite(FnamNoFrnt,[ noise(:,1) noise(:,4)],FAM);
% audiowrite(FnamNoMidd,[ noise(:,2) noise(:,5)],FAM);
% audiowrite(FnamNoRear,[ noise(:,3) noise(:,6)],FAM);

if( info.log )
    disp(['   Noise angle: ', num2str(no_paramt.AZN)])
%     disp('   Input signal measures:')
    disp(['     SNR_front_left : ', num2str(snr_front_left)]);
    disp(['     SNR_front_right: ', num2str(snr_front_right)]);
%     disp(['     PESQ_in_left : ', num2str(Pesq_in_left)]);
%     disp(['     PESQ_in_right: ', num2str(Pesq_in_right)]);
end

clear FnamInFrnt FnamInMidd FnamInRear FnamSpFrnt FnamSpMidd ...
    FnamSpRear FnamNoFrnt FnamNoMidd FnamNoRear FnamIn FnamOut ...
    FnamNoise;


% load(FnamIn); % DTS: distance to the speech source
                % ELS: elevation of the speech soirce
                % AZS: azimuth of the speech source
                % FAM: sampling frequency
                % HRIRSP: head related impulse responses for the speech
                % DIRSPEECH: directory of the speech file
                % NAMESPEECH: name of the speech file
                % DIRHRIR: directory of the head related impulse responses
                % speech_ori: original speech signal
                % speech_hri: binaural speech signals
                % speech_vad: voice activity detector
                % tamsign: input signal length 
                % numchan: number of microphones
