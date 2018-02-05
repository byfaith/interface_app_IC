function [noisySpeechCity, SignalAdj, NoiseAdj] = Convert2Cell(NS,n,VectorSNR,voice,fs_city,nbitsSig,S,FS,FSnew)
% Convert signals in Cell format, considering add noise to signal at
% different SNR level
% [noisySpeechCity, SignalAdj, NoiseAdj] = Convert2Cell(NS,n,VectorSNR,voice,fs_city,nbitsSig,S,FS,FSnew)
% Input
% NS        - number of speech signals
% n         - number of noisy segments
% VectorSNR - SNR vector
% voice     - speech signals (vector)
% fs_city   - sample frequency of noise
% nbitsSig  - signal bits
% S         - noise signals (vector)
% FS        - sample frequency of speech
% FSnew     - frequency required 
% Output
% noisySpeechCity - noisy signal
% SignalAdj       - clean signal
% NoiseAdj        - noise signal


%%
[pnoise,qnoise]=rat(fs_city/FSnew,0.0001);
% [pnoise,qnoise]=rat(FSnew/fs_city,0.0001);
[psignl,qsignl]=rat(FS/FSnew,0.0001);
% [psignl,qsignl]=rat(FSnew/FS,0.0001);
%%

noisySpeechCity = cell(size(VectorSNR,1),n,NS);
SignalAdj = cell(size(VectorSNR,1),n,NS);
NoiseAdj = cell(size(VectorSNR,1),n,NS);

disp('Generate signals...')

for p=1:1:NS                           % number of signals used
    for k=1:1:n                        % number of realizations
        for y=1:1:length(VectorSNR)    % number of SNR's
            
            % Resample signals to FSnew
            %voice_sampled=resample(voice(2:voice(1),p),psignl,qsignl);
            voice_sampled = voice(2:voice(1),p);
            %S_sampled=resample(S(1:length(voice_sampled),k),pnoise,qnoise);
            S_sampled = S(1:length(voice_sampled),k);

            [noisy, Signal, Noise] = s_and_n(voice_sampled,S_sampled,VectorSNR(y));
            % [noisy, ~, ~, Signal, Noise] = v_addnoise(voice_sampled,FS,VectorSNR(y),'A',S_sampled,FS);
            
            % Storage as cell formats
            noisySpeechCity{size(VectorSNR,1)+1,k,p} = strcat('Signal',num2str(k));
            SignalAdj{size(VectorSNR,1)+1,k,p} = strcat('Signal',num2str(k));
            NoiseAdj{size(VectorSNR,1)+1,k,p} = strcat('Signal',num2str(k));
            noisySpeechCity{y,k,p} = noisy;
            SignalAdj{y,k,p} = Signal;
            NoiseAdj{y,k,p} = Noise;
        end
    end
end

disp('Signals Generated!')

clear noisy;
clear Signal;
clear Noise;

end