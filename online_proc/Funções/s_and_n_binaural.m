function [S_mix, S, N] = s_and_n_binaural(S, N, SNRdb, earref)
%%
% Adds noise to the speech signal at a given signal to noise ratio (SNR)
% Adjust SNR in terms of left micrphone(front)
% 
% S_mix = s_and_n(S, N, SNRdb)
% 
%   -S_mix is the noisy signal at the specified SNR in dB.
%   -S and N are respectively the speech and noise arrays. 
%   -earref is the reference ear (1: left / 4: right)

%% evaluate SNR 
% P_S=norm(S(:,1),2)^2;    %sum(pwelch(S)); % signal power = sum(abs(X).^2)^(1/2)
% P_S=sum(pwelch(S(:,1)));
P_S=sum(pwelch(S(:,earref)));
% P_S=max(S)^2;
% P_N=norm(N(:,1),2)^2;   %sum(pwelch(N1)); % noise power
% P_N=sum(pwelch(N(:,1)));
P_N=sum(pwelch(N(:,earref)));
% P_N=max(N)^2;

SNR_in=P_S/P_N; %SNR of the input signals

SNR=10^(SNRdb/10);

a=sqrt(SNR_in/SNR); % parameter to adjust SNR to wanted value
% a=sqrt(10^((SNR-SNR_in)/10)); % parameter to adjust SNR to wanted value
N=a.*N;

S_mix=S+N;