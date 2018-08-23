%--------------------------------------------------------------------------
% Binaural_A_SpeechGenerator generates speech and ideal VAD signals.
%
% [1] H. Kayser, S.D. Ewert, J. Anem�ller, T. Rohdenburg, V. Hohmann, B. 
% Kollmeier (2009) Database of multichannel in-ear and behind-the-ear
% head-related and binaural room impulse responses. EURASIP Journal on
% Advances in Signal Processing, pages 1-10.
%
% [2] IEEE Subcommittee (1969)IEEE Recommended practice for speech 
% quality measurements. IEEE Transactions on Audio and Electroacoustics
% AU-17(3):225-246. 
% 
% Author    : Marcio Costa
% Created   : 01/07/2013
%--------------------------------------------------------------------------

function Binaural_A_SpeechGenerator2( DIROUT, DIRHRIR, DIRSPEECH, NAMOUT, sp_paramt, no_paramt, info )
                                 
if( info.log )
    disp('A: SPEECH GENERATOR');
end

%**************************************************************************
% Filenames
%**************************************************************************

FnamSpeech = strcat( DIRSPEECH, sp_paramt.NAMESPEECH, '.wav' );
if ~exist(FnamSpeech, 'file')
   FnamSpeech(end-2:end) = 'WAV';   %if the .wav file does not exist, change extension to .WAV 
end
FnamVad    = strcat( DIRSPEECH, sp_paramt.NAMESPEECH, '_DTS',num2str(sp_paramt.DTS), '_ELS', num2str(sp_paramt.ELS), '_AZS', num2str(sp_paramt.AZS), '_vad.mat' );
FnamSpOut  = strcat( DIROUT, sp_paramt.NAMESPEECH, '_DTS', num2str(sp_paramt.DTS), '_ELS', num2str(sp_paramt.ELS), '_AZS', num2str(sp_paramt.AZS), '_front.wav' );
FnamOut    = strcat( DIROUT, NAMOUT );

%**************************************************************************
% Load input files
%**************************************************************************

% speech  -----------------------------------------------------------------
[ speech_ori, FAM ] = audioread( FnamSpeech );

% vad ---------------------------------------------------------------------
% load( FnamVad );

% HRIR [1] ----------------------------------------------------------------
old = cd;
cd( DIRHRIR )
hrir = Load_hrir( 'Anechoic', sp_paramt.DTS, sp_paramt.ELS, sp_paramt.AZS, 'bte' ); % odd channel is left side
cd( old )
% HRIRSP = resample(hrir.data,FAM,48000); % resample to 16000Hz!?
HRIRSP = resample(hrir.data,FAM,16000); % resample to 16000Hz!?
clear old hrir;

numchan = size( HRIRSP, 2 );

%**************************************************************************
% Convolution with hrir
%**************************************************************************

% length of convolved signals ---------------------------------------------
tamsign = length(speech_ori) + length(HRIRSP(:,1)) - 1;

% convolved speech --------------------------------------------------------
speech_hri = zeros(tamsign,numchan);

if( no_paramt.AZN <= 0 )
    for cont = 1:numchan/2
       speech_hri( :, cont ) = conv( speech_ori, HRIRSP(:,2*(cont-1)+1), 'full' );
       speech_hri( :, cont+numchan/2 ) = conv( speech_ori, HRIRSP(:,2*cont), 'full' );
    end
elseif( no_paramt.AZN > 0 )
    for cont = 1:numchan/2
       speech_hri( :, cont ) = conv( speech_ori, HRIRSP(:,2*cont), 'full' );
       speech_hri( :, cont+numchan/2 ) = conv( speech_ori, HRIRSP(:,2*(cont-1)+1), 'full' );
    end
end
clear cont;

%**************************************************************************
% Voice activity detector
%**************************************************************************
activity   = max(abs(speech_hri)');


if( info.log )
    disp(['   Speech file: ', sp_paramt.NAMESPEECH]);
    disp(['   Time in seconds: ',num2str(tamsign/FAM)]);
end

if( info.plots )
    figure;
    tt = ( 0: tamsign-1 )/FAM;
    plot( tt, activity/max(activity), '-r' ); hold on; plot( tt, 0.1*speech_vad, '-b' );
end

% save( '.\Data\Speech\Activity_A_eng_m5_16kHz_0.5s_DTS300_ELS0_AZS0', 'activity' );

%**************************************************************************
% Save binaural data
%**************************************************************************

% save(FnamOut,'FAM','HRIRSP','DIRSPEECH','DIRHRIR','sp_paramt',...
%              'speech_ori','speech_hri','speech_vad','tamsign','numchan');

save(FnamOut,'FAM','HRIRSP','DIRSPEECH','DIRHRIR','sp_paramt',...
             'speech_ori','speech_hri','tamsign','numchan');
         
aux = 0.9/max(abs([ speech_hri(:,1) ; speech_hri(:,4)]));
% audiowrite( FnamSpOut, [ speech_hri(:,1) speech_hri(:,4)]*aux,FAM );

clear FnamSpeech FnamVad FnamOut activity aux;