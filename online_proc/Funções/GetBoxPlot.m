function [SNREstMean, SNRRelMean, MSEEstStd, DMSEEstMean, sigEstNoiseMean, sigRelNoiseMean, sigRelCleanMean, sigRelECleanMean] = GetBoxPlot(method, VectorSNR, n, NS, noisySpeechCity, SignalAdj, NoiseAdj, fs_babble)
% function [SNREstMean, sigEstNoiseMean, sigRelNoiseMean] = GetBoxPlot(method, VectorSNR, n, NS, noisySpeechCity, SignalAdj, NoiseAdj, fs_babble)
% Input
% method            -   Algorithm of PSD noise estimation 
% VectorSNR         -   SNR vector
% n                 -   number of noisy segments
% NS                -   number of speech signals
% noisySpeechCity   -   noisy signal
% SignalAdj         -   clean signal 
% NoiseAdj          -   noise signal 
% fs_babble         -   Resampled frequency
% Output
% SNREstMean        -   SNR estimated
% SNRRelMean        -   SNR measured
% MSEEstStd         -   Standard deviation of Distance Normalized
% DMSEEstMean       -   Normalized Distance
% sigEstNoiseMean   -   Average power of estimated noise
% sigRelNoiseMean   -   Average power of measured noise

SNRseg = cell(size(VectorSNR,1),n,NS);
SNRReal = cell(size(VectorSNR,1),n,NS);
DMSE = cell(size(VectorSNR,1),n,NS);
sigEstNoise = cell(size(VectorSNR,1),n,NS);
sigRelClean = cell(size(VectorSNR,1),n,NS);
sigRelEClean = cell(size(VectorSNR,1),n,NS);
sigRelNoise = cell(size(VectorSNR,1),n,NS);
SNRAvrPerRep = zeros(n,1);
SNRAvrPerRepR = zeros(n,1);
DMSEAvrPerRepR = zeros(n,1);
sigEstNoiseRep = zeros(n,1);
sigRelNoiseRep = zeros(n,1);
sigRelCleanRep = zeros(n,1);
sigRelECleanRep = zeros(n,1);
SNREst = zeros(size(VectorSNR,1),NS);
SNRRel = zeros(size(VectorSNR,1),NS);
DMSERel = zeros(size(VectorSNR,1),NS);
sigEstNoiseDef = zeros(size(VectorSNR,1),NS);
sigRelNoiseDef = zeros(size(VectorSNR,1),NS);
sigRelCleanDef = zeros(size(VectorSNR,1),NS);
sigRelECleanDef = zeros(size(VectorSNR,1),NS);

disp(['Estimating SNR based on: ' method])

for p=1:length(VectorSNR)   % For each SNR
    for r=1:1:NS            % For each signal
        for q=1:1:n         % For each repetition
            
%             SNRseg{p,q,r} = specsub_ns(noisySpeechCity{p,q,r},fs_babble,...
%                 'mcra','FileFilted');
            
            % Get snr and msE estimated considering diff. methods
            [SNRseg{p,q,r}, SNRReal{p,q,r}, DMSE{p,q,r}, ...
                sigEstNoise{p,q,r}, sigRelNoise{p,q,r}, ...
                sigRelClean{p,q,r}, sigRelEClean{p,q,r}, ~] = ...
                ics_constr_rule(noisySpeechCity{p,q,r}, ...
            	SignalAdj{p,q,r}, NoiseAdj{p,q,r}, fs_babble, 'Fout', ...
                'Wiener', method, 'Cappe');                
            
            SNRAvrPerRep(q) = SNRseg{p,q,r};
            SNRAvrPerRepR(q) = SNRReal{p,q,r};
            DMSEAvrPerRepR(q) = DMSE{p,q,r};
            sigEstNoiseRep(q) = sigEstNoise{p,q,r};
            sigRelNoiseRep(q) = sigRelNoise{p,q,r};
            sigRelCleanRep(q) = sigRelClean{p,q,r};
            sigRelECleanRep(q) = sigRelEClean{p,q,r};
        end
        SNREst(p,r) = mean(SNRAvrPerRep);
        SNRRel(p,r) = mean(SNRAvrPerRepR);
        DMSERel(p,r) = mean(DMSEAvrPerRepR);
        sigEstNoiseDef(p,r) = mean(sigEstNoiseRep);
        sigRelNoiseDef(p,r) = mean(sigRelNoiseRep);
        sigRelCleanDef(p,r) = mean(sigRelCleanRep);
        sigRelECleanDef(p,r) = mean(sigRelECleanRep);
        
        SNRAvrPerRep = zeros(n,1);
        sigEstNoiseRep = zeros(n,1);
        sigRelNoiseRep = zeros(n,1);
    end
end
disp(['Done: ' method])

% boxplot(SNREst',{-20 -15 -10 -5 0 5 10 15 20})
% xlabel('SNR(dB)')
% ylabel('SNR_{estimada}(dB)')
% ylabel('MSE')
% ylabel('Distância Normalizada')
title(method)

SNREstMean = mean(SNREst,2);
MSEEstStd = std(DMSERel');
SNRRelMean = mean(SNRRel,2);
DMSEEstMean = mean(DMSERel,2);
sigEstNoiseMean = mean(sigEstNoiseDef,2);
sigRelNoiseMean = mean(sigRelNoiseDef,2);
sigRelCleanMean = mean(sigRelCleanDef,2);
sigRelECleanMean = mean(sigRelECleanDef,2);
