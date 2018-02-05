function [parameters] = mmsepsd_estimation(ns_ps,parameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file containes an implementation of the noise PSD tracker
%%%%presented in the article: "MMSE BASED NOISE PSD TRACKING WITH LOW COMPLEXITY", by R. C.  Hendriks, R. Heusdens and J. Jensen published at the
%%%%IEEE International Conference on Acoustics, Speech and Signal
%%%%Processing, 03/2010, Dallas, TX, p.4266-4269, (2010).
%%%%Input parameters:   noisy:  noisy signal
%%%%                     fs:   sampling frequency of noisy signal
%%%%
%%%% Output parameters:  noisePowMat:  matrix with estimated noise PSD for each frame
%%%%                    shat:      estimated clean signal
%%%%                    T:      processing time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%copyright: Delft university of Technology
%%%%%%%%%%%%%%%%%%%%% update 14-11-2011: tabulatede special function to
%%%%%%%%%%%%%%%%%%%%% speed up computations.


%         parameters = struct('n',1,'g_mag',g_mag,'len',len_val,'tabel_inc_gamma',...
%             tabel_inc_gamma,'ALPHA',ALPHA,'SNR_LOW_LIM',SNR_LOW_LIM,...
%             'noise_psd',noise_psd,'MIN_GAIN',MIN_GAIN,'nFrame',nFrame,...
%             'min_mat',min_mat,'Srate',Srate,'noise_ps',noise_ps);

g_mag = parameters.g_mag;
fft_size = parameters.len;
ALPHA = parameters.ALPHA;
MIN_GAIN = parameters.MIN_GAIN;
SNR_LOW_LIM = parameters.SNR_LOW_LIM;
clean_est_dft_frame_p=[];
% indFr = parameters.nFrame;
n = parameters.n;
tabel_inc_gamma = parameters.tabel_inc_gamma;
min_mat = parameters.min_mat;
fs = parameters.Srate;
% noise_ps = parameters.noise_ps;

if n==1
    noise_psd = parameters.noise_psd;
else
    noise_psd = parameters.noise_ps;
end

%noisy_dft_frame_p = ns_ps(1:fft_size/2+1);
noisy_dft_frame_p = ns_ps(1:end);

indFr = n;

[a_post_snr_bias,a_priori_snr_bias]=estimate_snrs_bias(noisy_dft_frame_p,fft_size ,noise_psd, SNR_LOW_LIM,  ALPHA  ,indFr,clean_est_dft_frame_p)   ;
speech_psd=a_priori_snr_bias.*noise_psd;
[noise_psd ]=noise_psdest_tab1(noisy_dft_frame_p, indFr, speech_psd,noise_psd,tabel_inc_gamma);

% min_mat=[min_mat(:,end-floor(0.8*fs/(fft_size/2))+2:end),noisy_dft_frame_p(1:fft_size/2+1)    ];
% min_mat=[min_mat(:,end-floor(0.8*fs/(fft_size/2))+2:end),noisy_dft_frame_p(1:end)    ];

% noise_psd=max(noise_psd,min(min_mat,[],2));
    
[a_post_snr,a_priori_snr   ]=estimate_snrs(noisy_dft_frame_p,fft_size, noise_psd,SNR_LOW_LIM,  ALPHA   ,indFr,clean_est_dft_frame_p)   ;
[gain]= lookup_gain_in_table(g_mag,a_post_snr,a_priori_snr,-40:1:50,-40:1:50,1);
gain=max(gain,MIN_GAIN);
noise_psd_matrix = noise_psd;

parameters.noise_ps = noise_psd;
parameters.g_mag = g_mag;
% parameters.noise_psd = noise_psd;
parameters.len = fft_size;
parameters.ALPHA = ALPHA;
parameters.MIN_GAIN = MIN_GAIN;
parameters.SNR_LOW_LIM = SNR_LOW_LIM;
clean_est_dft_frame_p=[];
% parameters.nFrame = indFr+1;
parameters.n = n+1;
parameters.tabel_inc_gamma = tabel_inc_gamma;
parameters.min_mat = min_mat;
parameters.Srate = fs;


%clean_est_dft_frame=gain.*noisyDftFrame(1:fft_size/2+1);