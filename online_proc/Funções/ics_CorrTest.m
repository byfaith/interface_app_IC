function [xfinal,tElapsed] = ics_CorrTest(x, cl, noise, Srate, outfile, thrd, method)
% function xfinal = ics_twoChannels(x, cl, noise, Srate, outfile, thrd, method)
% Input
% x                 -   noisy speech filename (mixture from two mic.)
% cl                -   clean speech filename (mixture from two mic.)
% noise             -   noise signal filename (mixture from two mic.)
% Srate             -   sampling rate
% outilfe           -   name of output file
% thrd              -   the threshold for binary masking (in dB)
% method            -   Algorithm of PSD noise estimation 
% Output
% xfinal            -   Filtered signal
% tElapsed          -   Elapsed processed time (matrix of frames)
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
nFFT2=round(nFFT/2);
win = hanning(len);                             % Analysis window
%%

%--- allocate memory and initialize various variables
% Nframes = floor(size(x,1)/len2)-1;
xfinal = zeros(Nframes*len2,1);

%  masking threshold

thrd = 10^(thrd/10);

%% Initialize noise estimate
noise_mean1 = zeros(nFFT,1);            % Channel 1
j=1;
for k=1:4
   magn1 = abs(fft(win.*x(j:j+len-1,1),nFFT)).^2;
   noise_mean1 = noise_mean1+magn1;
   j = j+len;
end
noise_initial1 = noise_mean1/4;

noise_mean2 = zeros(nFFT,1);            % Channel 2
j=1;
for k=1:4
   magn2 = abs(fft(win.*x(j:j+len-1,2),nFFT)).^2;
   noise_mean2 = noise_mean2+magn2;
   j = j+len;
end
noise_initial2 = noise_mean2/4;
%%
%% ===========  used mmsepsd_estimation   ============
% This function computes the initial noise PSD estimate from channel 1
% noise_psd1 = init_noise_tracker_ideal_vad(x(:,1),len,nFFT,len2,sqrt(win)); 
noise_psd1 = init_noise_tracker_ideal_vad(x(:,1),len,nFFT,len2,(win)); 

% This function computes the initial noise PSD estimate from channel 2
% noise_psd2 = init_noise_tracker_ideal_vad(x(:,2),len,nFFT,len2,sqrt(win));
noise_psd2 = init_noise_tracker_ideal_vad(x(:,2),len,nFFT,len2,(win));

min_mat=zeros(nFFT/2+1,floor(0.8*Srate/(Nframes/2)));

%%
%===========  Start Processing    ============
k = 1;
x_old = zeros(len1,1);

BMask=zeros(Nframes,nFFT2);
%%
tElapsed = zeros(Nframes,1);

for i = 1:Nframes
    %------ channel 1
%     (k:k+len-1)
%     disp(['win= ', num2str(size(win))])
%     disp(['x= ', num2str(size(x(k:k+len-1,1)))])
    
    % ------ Initialize measure of processing time ------
    tStart = tic;
    % ------                                       ------

    insign1 = win.*x(k:k+len-1,1);       % noisy signal
    cl_sign1 = win.*cl(k:k+len-1,1);     % clean signal
    tn1 = win.*n(k:k+len-1,1);           % noise (masker)
   
    %--- Take fourier transform of  frame

    spec1 = fft(insign1,nFFT);          % noisy speech spectrum
    sig1 = abs(spec1);                  % compute the magnitude
    sig2_1 = sig1.^2;

    cl_spec1 = fft(cl_sign1,nFFT);      % clean speech spectrum
    cl_sig1 = abs(cl_spec1);            % compute the magnitude
    cl_sig2_1 = cl_sig1.^2;

    tn_spec1 = fft(tn1,nFFT);
    tn_sig1 = abs(tn_spec1);            % compute the magnitude
    tn_sig2_1 = tn_sig1.^2;
    
    %%
    %------ channel 2
    insign2 = win.*x(k:k+len-1,2);       % noisy signal
    cl_sign2 = win.*cl(k:k+len-1,2);     % clean signal
    tn2 = win.*n(k:k+len-1,2);           % noise (masker)
   
    %--- Take fourier transform of  frame

    spec2 = fft(insign2,nFFT);          % noisy speech spectrum
    sig2 = abs(spec2);                  % compute the magnitude
    sig2_2 = sig2.^2;

    cl_spec2 = fft(cl_sign2,nFFT);      % clean speech spectrum
    cl_sig2 = abs(cl_spec2);            % compute the magnitude
    cl_sig2_2 = cl_sig2.^2;

    tn_spec2 = fft(tn2,nFFT);
    tn_sig2 = abs(tn_spec2);            % compute the magnitude
    tn_sig2_2 = tn_sig2.^2;

    %% Estimate noise spectrum (channel 1)
    % use noise estimation algorithm
    if i==1
        parameters1 = initialise_parameters(noise_initial1,Srate,method,...
            noise_psd1,i,min_mat,Nframes);
        parameters1 = noise_estimation(noise_initial1, method, parameters1); 
    else
       parameters1 = noise_estimation(sig2_1, method, parameters1); 
    end
    noise_mu2_1 = parameters1.noise_ps;
    noise_mu_1 = sqrt(noise_mu2_1);         % magnitude spectrum    
    
    noise_mu2_1 = mean(noise_mu2_1,2);      % get average of last frames
    noise_mu_1 = mean(noise_mu_1,2);        % get average of last frames
    
    
    %% Estimate noise spectrum (channel 2)
    % use noise estimation algorithm
    if i==1
        parameters2 = initialise_parameters(noise_initial2,Srate,method,...
            noise_psd2,i,min_mat,Nframes);
        parameters2 = noise_estimation(noise_initial2, method, parameters2); 
    else
       parameters2 = noise_estimation(sig2_2, method, parameters2); 
    end
    noise_mu2_2 = parameters2.noise_ps;
    noise_mu_2 = sqrt(noise_mu2_2);         % magnitude spectrum    
    
    noise_mu2_2 = mean(noise_mu2_2,2);      % get average of last frames
    noise_mu_2 = mean(noise_mu_2,2);        % get average of last frames

    %% Alterate SNR estimation considering estimation of noise psd algor.
    % ksi_IEC = cl_sig2./tn_sig2;  % True instantaneous SNR
    %ksi_IEC = cl_sig2./sig2;  % True instantaneous SNR
    
    %% SNR estimated based on algorithm to PSD estimation

    % Compare which signal has the highest SNR (lowest noise power)
    
    % Compare on a average bin values base
    if (mean(noise_mu2_1) < mean(noise_mu2_2))
        
        %%
%         ksi_IEC = (sig2_1-noise_mu2_1)./noise_mu2_1;
        ksi_IEC = (sig1-noise_mu_1)./noise_mu_1;
        
        % binary masking
        hw = ones(len1,1);
        ind = find(ksi_IEC(1:len1)<thrd);
        hw(ind) = 0;
        BMask(i,1:nFFT2)=1-hw(1:nFFT2); 

        hw = [hw ;hw(end:-1:1)];
        xi_w = ifft( hw .* spec1);   % synthesize binary-masked signal
        %xi_w = ifft( hw .* tn_spec);   % synthesize  signal by modulating mask by noise 
        xi_w = real( xi_w);

        % --- Overlap and add ---------------
        %
        %xfinal(k:k+ len2-1) = x_old+ xi_w(1:len1);
        xfinal(k:k+ len1-1) = x_old+ xi_w(1:len1);
        %x_old = xi_w(len1+ 1: len);
        x_old = xi_w(len2+ 1: len);
        k=k+len2;

    else
        %%
%         ksi_IEC = (sig2_2-noise_mu2_2)./noise_mu2_2;
        ksi_IEC = (sig2-noise_mu_2)./noise_mu_2;
        
        % binary masking
        hw = ones(len1,1);
        ind = find(ksi_IEC(1:len1)<thrd);
        hw(ind) = 0;
        BMask(i,1:nFFT2)=1-hw(1:nFFT2); 

        hw = [hw ;hw(end:-1:1)];
        xi_w = ifft( hw .* spec2);   % synthesize binary-masked signal
        %xi_w = ifft( hw .* tn_spec);   % synthesize  signal by modulating mask by noise 
        xi_w = real( xi_w);

        % --- Overlap and add ---------------
        %
        %xfinal(k:k+ len2-1) = x_old+ xi_w(1:len1);
        xfinal(k:k+ len1-1) = x_old+ xi_w(1:len1);
        %x_old = xi_w(len1+ 1: len);
        x_old = xi_w(len2+ 1: len);
        k=k+len2;
    end
    
	% ------                                       ------
    tElapsed(i,1) = toc(tStart);
%     disp(['Elapsed time:: ', num2str(tElapsed(i,1))]);
    % ------                                       ------    
    
end
%========================================================================================


%xfinal = xfinal/32768;
if max(abs(xfinal))>1 %32768
    xfinal = xfinal*0.6/max(abs(xfinal));
%     fprintf('Max amplitude exceeded 1 for file %s\n',clfile);
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

