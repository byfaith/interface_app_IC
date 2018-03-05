% 
% This script demonstrates the use of the CI Vocoder 
% from Br�cker, T. et al. (2009): Simulation und Vergleich von
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
% [Original_sound, fs] = audioread('M0001001.wav');
[Original_sound, fs] = audioread('F0009005.wav');
lenOr = length(Original_sound);

% Unprocessed
% [Original, fs] = audioread('F0002007_S0N90_SNR0_Un.wav');
% [Original, fs] = audioread('M0001001_S0N90_SNR0_Un.wav');
% [Original, fs] = audioread('F0009005_S0N90_SNR0_Un.wav');
% Original = Original(1:lenOr,2);

% MMSE
% M0001001_S0N90_SNR0_Un
% F0009005_S0N90_SNR0_Un
% [Original, fs] = audioread('F0002007_S0N90_SNR0_MMSE.wav');
% [Original, fs] = audioread('M0001001_S0N90_SNR0_MMSE.wav');
[Original, fs] = audioread('F0009005_S0N90_SNR0_MMSE.wav');
Original = Original(1:lenOr,2);

% Wiener
% [Original, fs] = audioread('F0002007_S0N90_SNR0_Wiener.wav');
% [Original, fs] = audioread('M0001001_S0N90_SNR0_Wiener.wav');
% [Original, fs] = audioread('F0009005_S0N90_SNR0_Wiener.wav');
% Original = Original(1:lenOr,2);

% Bnary Mask
% [Original, fs] = audioread('F0002007_S0N90_SNR0_Binary Mask.wav');
% [Original, fs] = audioread('M0001001_S0N90_SNR0_Binary Mask.wav');
% [Original, fs] = audioread('F0009005_S0N90_SNR0_Binary Mask.wav');
% Original = Original(1:lenOr,2);

% Use the Vocoder with CI simulation and the MED-EL simulation
% Vocoded_Male_MEDEL = CI_Vocoder_MEDEL(Original_Male, fs, 'CI');
% Vocoded_Female_MEDEL = CI_Vocoder_MEDEL(Original_Female, fs, 'CI');

% Use the Vocoder with CI simulation and the Cochlear Nucleus simulation
[Vocoded_Male_Cochlear, electrodeband] = CI_Vocoder_Cochlear(Original, fs, 'CI');
Vocoded_Female_Cochlear_2 = CI_Vocoder_Cochlear(Original_sound, fs, 'CI');

% Preperation and presentation of original and vocoded signal
Silence = zeros(fs, 1)';
% Presentation = [Original_Male' Silence Vocoded_Male_MEDEL' Silence Vocoded_Male_Cochlear' Silence ...
%                 Original_Female' Silence Vocoded_Female_MEDEL' Silence Vocoded_Female_Cochlear'];
Presentation = [Original_sound' Silence Vocoded_Female_Cochlear_2'...
    Silence Vocoded_Male_Cochlear'];
player = audioplayer(Presentation, fs);
play(player);

% End of File