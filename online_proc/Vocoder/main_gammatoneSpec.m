% 
% This script demonstrates the use of the CI Vocoder 
% from Bräcker, T. et al. (2009): Simulation und Vergleich von
% Sprachkodierungsstrategien in Cochlea-Implantaten. 
% Zeitschrift der Audiologie, 48(4):158-169.
% 
% Author:   Florian Langner
% Version:  1.00
% Date:     12.03.15
% 
% Modified: Gustavo Mourao (03/02/2018)

clc; clear all; close all;
addpath('CI Vocoder');

% Load the wav files into Matlab
% Clean
% [Original_sound, fs] = audioread('F0002007.wav');
[Original_sound, fs] = audioread('M0001001.wav');
% [Original_sound, fs] = audioread('F0009005.wav');
lenOr = length(Original_sound);

% Unprocessed
% [Original_Un, fs] = audioread('F0002007_S0N90_SNR5_Un.wav');
[Original_Un, fs] = audioread('M0001001_S0N90_SNR0_Un.wav');
% [Original_Un, fs] = audioread('F0009005_S0N90_SNR0_Un.wav');
Original_Un = Original_Un(1:lenOr,2);

% MMSE
% M0001001_S0N90_SNR0_Un
% F0009005_S0N90_SNR0_Un
% [Original_MMSE, fs] = audioread('F0002007_S0N90_SNR5_MMSE.wav');
[Original_MMSE, fs] = audioread('M0001001_S0N90_SNR0_MMSE.wav');
% [Original_MMSE, fs] = audioread('F0009005_S0N90_SNR0_MMSE.wav');
Original_MMSE = Original_MMSE(1:lenOr,2);

% Wiener
% [Original_Wiener, fs] = audioread('F0002007_S0N90_SNR5_Wiener.wav');
[Original_Wiener, fs] = audioread('M0001001_S0N90_SNR0_Wiener.wav');
% [Original_Wiener, fs] = audioread('F0009005_S0N90_SNR0_Wiener.wav');
Original_Wiener = Original_Wiener(1:lenOr,2);

% Binary Mask
% [Original_BMsk, fs] = audioread('F0002007_S0N90_SNR5_Binary Mask.wav');
[Original_BMsk, fs] = audioread('M0001001_S0N90_SNR0_Binary Mask.wav');
% [Original_BMsk, fs] = audioread('F0009005_S0N90_SNR0_Binary Mask.wav');
Original_BMsk = Original_BMsk(1:lenOr,2);

% Use the Vocoder with CI simulation and the Cochlear Nucleus simulation
% Original
Original_vocoder = CI_Vocoder_Cochlear(Original_sound, fs, 'CI');

% Unproc.
Un_vocoder = CI_Vocoder_Cochlear(Original_Un, fs, 'CI');

% MMSE
MMSE_vocoder = CI_Vocoder_Cochlear(Original_MMSE, fs, 'CI');

% Wiener
Wiener_vocoder = CI_Vocoder_Cochlear(Original_Wiener, fs, 'CI');

% BMsk
BMsk_vocoder = CI_Vocoder_Cochlear(Original_BMsk, fs, 'CI');

% [Vocoded_Male_Cochlear, electrodeband] = CI_Vocoder_Cochlear(Original_MMSE, fs, 'CI');
% Vocoded_Female_Cochlear_2 = CI_Vocoder_Cochlear(Original_sound, fs, 'CI');


% Preperation and presentation of original and vocoded signal
Silence = zeros(fs, 1)';

% Presentation = [Original_Male' Silence Vocoded_Male_MEDEL' Silence Vocoded_Male_Cochlear' Silence ...
%                 Original_Female' Silence Vocoded_Female_MEDEL' Silence Vocoded_Female_Cochlear'];
Presentation = [Original_sound' Silence Original_vocoder' Silence Un_vocoder'...
    Silence MMSE_vocoder'];
player = audioplayer(Presentation, fs);
play(player);


%% Obtain envolope signal (Hibert)
% close all
% winLen = 300;
% [upOr, loOr] = envelope(Original_vocoder,winLen,'rms');
% [upUn, loUn] = envelope(Original_Un,winLen,'rms');
% [upMMSE, loMMSE] = envelope(Original_MMSE,winLen,'rms');
% [upWiener, loWiener] = envelope(Original_Wiener,winLen,'rms');
% [upBMsk, loBMsk] = envelope(Original_BMsk,winLen,'rms');
% 
% figure;
% t = 0:1/fs:(length(upOr)-1)/fs;
% plot(t, upOr, 'k')
% hold on
% t1 = 0:1/fs:(length(upUn)-1)/fs;
% plot(t1, upUn, 'b')
% plot(t1, upMMSE, 'r')
% plot(t1, upWiener, 'g')
% plot(t1, upBMsk, 'm')
% h = legend('Clean', 'Unprocessed', 'MMSE', 'Wiener', 'Binary Mask');
% set(h);
% title('Envelope Amplitude')
% xlabel('time[s]')
% ylabel('Amplitude')
% End of File