function xfinal = ics(x, cl, noise, Srate, outfile, thrd, method)
% function xfinal = ics(x, cl, noise, Srate, outfile, thrd, method)
% noisefile - name of masker file
% clfile - name of clean sentence file
% outfile - name of output (processed) file
% nsnr is the overall input SNR (in dB) for noisy file
% thrd is the threshold for binary masking (in dB)
% method            -   Algorithm of PSD noise estimation 
%
%  Copyright (c) 2011 by Philipos C. Loizou


% if nargin<5
%     fprintf('ERROR Usage: ics (MaskerFile,CleanFile,OutputFile,SNR,Threshold)\n');
%     return;
% end
% 
% 
% [cl,fs,nb] = wavread(clfile);
% cl = cl -mean(cl);
% 
% [n0,fs2,nb] = wavread(noisefile); 
% if fs2~=fs
%     error('Sampling frequency of masker file does not match that of target file');
% end
% 
% n = n0(1:length(cl));
% n = n - mean(n);
% 
% 
% %--
% 
% %----scale the noise file to get required SNR------------
% %
% se=norm(cl,2)^2; %... signal energy
% nsc=se/(10^(nsnr/10));
% ne=norm(n,2)^2;  % noise energy
% n=sqrt(nsc/ne)*n; % scale noise energy to get required SNR
% ne=norm(n,2)^2;
% %fprintf('Estimated SNR=%f\n',10*log10(se/ne));
% x = cl + n;    % the noisy signal
% 
% ind1 = find(clfile == '.');
% wavwrite(x,fs,16,[clfile(1:ind1-1) '-noisy.wav']); % save noisy signal

%%
% =============== Initialize variables ===============
%
% len = floor(20*fs/1000); % Frame size in samples
% if rem(len,2)==1, len=len+1; end;
% PERC = 50; % window overlap in percent of frame size
% len1 = floor(len*PERC/100);
% len2 = len-len1;
% 
% win = hanning(len);
% nFFT = len;
% nFFT2=round(nFFT/2);


%%
% =============== Initialize variables / Parameters ===============

n = noise;
fs = Srate;                                     % Reference sampling frequecy 

overlap = 0.5;                                  % window overlap 
winLen = 128;                                   % Size of STFT analysis window, it can be reset by the user
fraShi = round(winLen*(1-overlap));             % Frame shift for consecutive frames (len2)
freRan = 1:winLen/2;                            % Frequency range to be considered
freNum = length(freRan);                        % Frequency number (len1)
fraNum = fix((length(x)-winLen)/fraShi+1);      % Frame number (Nframes)
% Noise magnitude calculations - assuming that the first 4 frames is
% noise/silence
Nframes = fraNum; 
len2 = fraShi;
len1 = freNum;
len = len1+len2;
nFFT = len;
win = hanning(len);                             % Analysis window

nFFT2=round(nFFT/2);


%%

%--- allocate memory and initialize various variables
% Nframes = floor(length(x)/len2)-1;
xfinal = zeros(Nframes*len2,1);

%  masking threshold

thrd = 10^(thrd/10);

%% ------ Decisioni-Directed
aa = 0.98;
Bc = 4/pi;


%% Initialize noise estimate
noise_mean=zeros(nFFT,1);
j=1;
for k=1:4
   magn=abs(fft(win.*x(j:j+len-1),nFFT)).^2;
   noise_mean=noise_mean+magn;
   j=j+len;
end
noise_initial=noise_mean/4;
%%
%% ===========  used mmsepsd_estimation   ============
% noise_psd = init_noise_tracker_ideal_vad(x,len,nFFT,len2,...
%     sqrt(win)); % This function computes the initial noise PSD estimate. It is assumed
% % that the first 5 time-frames are noise-only.

noise_psd = init_noise_tracker_ideal_vad(x,len,nFFT,len2,...
    (win)); % This function computes the initial noise PSD estimate. It is assumed
% that the first 5 time-frames are noise-only.


min_mat=zeros(nFFT/2+1,floor(0.8*Srate/(Nframes/2)));
%%
%===========  Start Processing    ============
k = 1;
x_old = zeros(len1,1);

BMask=zeros(Nframes,nFFT2);
%%

for i = 1:Nframes

    insign = win.*x(k:k+len-1);  % noisy signal
    cl_sign = win.*cl(k:k+len-1);  % clean signal
    tn = win.*n(k:k+len-1);      % noise (masker)
   
    %--- Take fourier transform of  frame

    spec = fft(insign,nFFT);  % noisy speech spectrum
    sig = abs(spec); % compute the magnitude
    sig2 = sig.^2;

    cl_spec = fft(cl_sign,nFFT);  % clean speech spectrum
    cl_sig = abs(cl_spec); % compute the magnitude
    cl_sig2 = cl_sig.^2;

    tn_spec = fft(tn,nFFT);
    tn_sig = abs(tn_spec); % compute the magnitude
    tn_sig2 = tn_sig.^2;
    

%% Estimate noise spectrum
 % use noise estimation algorithm
    if i==1
        parameters = initialise_parameters(noise_initial,Srate,method,...
            noise_psd,i,min_mat,Nframes);
        parameters = noise_estimation(noise_initial, method, parameters); 
    else
       parameters = noise_estimation(sig2, method, parameters); 
    end
    noise_mu2 = parameters.noise_ps;
    noise_mu = sqrt(noise_mu2);         % magnitude spectrum    
    
    noise_mu2 = mean(noise_mu2,2);      % get average of last frames
    noise_mu = mean(noise_mu,2);        % get average of last frames
    
    

    %% Alterate SNR estimation considering estimation of noise psd algor.
%     ksi_IEC = cl_sig2./tn_sig2;  % True instantaneous SNR
    %ksi_IEC = cl_sig2./sig2;  % True instantaneous SNR
    
    %% SNR estimated based on algorithm to PSD estimation
    ksi_IEC = (sig2-noise_mu2)./noise_mu2; %% This!
% 	ksi_IEC = (sig2-noise_mu)./sig2;
%     figure;plot(10.*log10(abs(ksi_IEC)),'r')
    
    
%     gammak = min(sig2./noise_mu2,20);
%     if i==1
%         
%         ksi2 = aa+(1-aa)*max(gammak-1,0);
%         ksi2 = max(ksi2,0.0025);
%         
%     else   
%         ksi2 = aa*Bc*Xk_prev./noise_mu2 + (1-aa)*max(gammak-1,0); % Traditional a priori SNR in MMSE                    
%         ksi2 = max(ksi2,0.0025);
%     end
%     ksi_IEC = ksi2; 


    %%

    % binary masking
    hw = ones(len1,1);
    ind = find(ksi_IEC(1:len1)<thrd);
%     ind = find(ksi_IEC(1:len1)<mean(ksi_IEC));      % Global mix estim. SNR
    hw(ind) = 0;
    BMask(i,1:nFFT2)=1-hw(1:nFFT2); 

    hw = [hw ;hw(end:-1:1)];
    xi_w = ifft( hw .* spec);   % synthesize binary-masked signal
    %xi_w = ifft( hw .* tn_spec);   % synthesize  signal by modulating mask by noise 
    xi_w = real( xi_w);

    % --- Overlap and add ---------------
    %
    xfinal(k:k+ len2-1) = x_old+ xi_w(1:len1);
    x_old = xi_w(len1+ 1: len);
    k=k+len2;
end
%========================================================================================


%xfinal = xfinal/32768;
if max(abs(xfinal))>1.0; %32768
    xfinal = xfinal*0.6/max(abs(xfinal));
    fprintf('Max amplitude exceeded 1 for file %s\n',clfile);
end



% wavwrite(xfinal,fs,16,outfile);
% 
% imagesc(BMask)
% 
% handle = imagesc([0 length(cl)/fs],[0 fs/2],BMask'); 
% axis('xy');
% colormap('gray')
% xlabel('Time (secs)'); ylabel ('Freq. (Hz)');
% axis([0 length(cl)/fs  0 fs/2]);

    

return;

