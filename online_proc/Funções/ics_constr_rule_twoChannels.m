function  [SNREst, SNRReal, MSEAvg, sigEstNoise, sigRelNoise, sigEstClean, sigRelEstClean, xfinal] = ics_constr_rule_twoChannels(x, cl, noise, Srate, outfile, GAIN, method)
% function  [SNREst, SNRReal, MSEAvg, sigEstNoise, sigRelNoise, sigEstClean, sigRelEstClean] = ics_constr_rule(x, cl, noise, Srate, outfile, GAIN, method)
% Input
%   x                 -   noisy speech filename (mixture from two mic.)
%   cl                -   clean speech filename (mixture from two mic.)
%   noise             -   noise signal filename (mixture from two mic.)
%   Srate             -   sampling rate
%   outilfe           -   name of output file
%   GAIN      -   'Wiener'; 'MMSE', 'logMMSE', 'MMSE-SPU'; 'pMMSE'; 'SpecSub'
%   method            -   Algorithm of PSD noise estimation 
% Output
%   SNREst            -   SNR estimated
%   SNRReal           -   SNR measured
%   MSEAvg            -   Normalized distance
%   sigEstNoise       -   Average power of estimated noise
%   sigRelNoise       -   Average power of measured noise
%   sigEstClean       -   Average power of measured clean speech
%   sigRelEstClean    -   Average power of estimated (Y - V)
%   xfinal            -   Filtered signal
%
%  Updated Sept 26, 2011 - corrected windowing (PL)
%
%  Copyright (c) 2011 by Philipos C. Loizou
%   Modify by Gustavo Mourao - 2018

if nargin<4
    fprintf('ERROR Usage: ics_constr_rule(MixtureFile,CleanFile,OutputFile,GainType)\n');
    return;
end

% method = 'mcra2'; % noise-estimation algorithm (Rangachari & LOizou, Speech Comm., 2006)

% [x, Srate, nb] = wavread(filename);  % noisy speech
% [cl,Srate2,nb] = wavread(clfile); 


% =============== Initialize variables ===============
%
% len = floor(20*Srate/1000); % Frame size in samples
% % len = floor(256*Srate/8000); % Frame size in samples
% if rem(len,2)==1, len=len+1; end;
% PERC = 50; % window overlap in percent of frame size
% len1 = floor(len*PERC/100);
% len2 = len-len1; 
% 
% win = hanning(len); 
% % win = hanning(512); 
% 
% % Noise magnitude calculations - assuming that the first 4 frames is
% % noise/silence
% nFFT = len;
% % nFFT = 512;

%%
% =============== Initialize variables / Parameters ===============
overlap = 0.5;                                  % window overlap 
% fs = 16000;                                   % Reference sampling frequecy 
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


%% Initialize noise estimate

noise_mean1=zeros(nFFT,1);       % channel 1
j=1;
for k=1:4
   magn1=abs(fft(win.*x(j:j+len-1,1),nFFT)).^2;
   noise_mean1=noise_mean1+magn1;
   j=j+len;
end
noise_initial1=noise_mean1/4;


noise_mean2=zeros(nFFT,1);       % channel 2
j=1;
for k=1:4
   magn2=abs(fft(win.*x(j:j+len-1,2),nFFT)).^2;
   noise_mean2=noise_mean2+magn2;
   j=j+len;
end
noise_initial2=noise_mean2/4;
%%

%--- allocate memory and initialize various variables
   
k = 1;
x_old = zeros(len1,1);
% Nframes = floor(size(x,1)/len2)-1;
xfinal = zeros(Nframes*len2,1);


%% ===========  initialize parameters   ============
k = 1;
aa = 0.98; % Decisioni-Directed
c = sqrt(pi)/2;
p=-1;
CC=gamma((p+3)/2)/gamma(p/2+1);
Bc=4/pi;


m=1; 
nFFT2=floor(nFFT/2);


%% ===========  used mmsepsd_estimation   ============
% noise_psd = init_noise_tracker_ideal_vad(x,len,nFFT,len2,...
%     sqrt(win)); % This function computes the initial noise PSD estimate. It is assumed
% % that the first 5 time-frames are noise-only.

% This function computes the initial noise PSD estimate from channel 1
% noise_psd1 = init_noise_tracker_ideal_vad(x(:,1),len,nFFT,len2,sqrt(win)); 
noise_psd1 = init_noise_tracker_ideal_vad(x(:,1),len,nFFT,len2,(win)); 

% This function computes the initial noise PSD estimate from channel 2
% noise_psd2 = init_noise_tracker_ideal_vad(x(:,2),len,nFFT,len2,sqrt(win));
noise_psd2 = init_noise_tracker_ideal_vad(x(:,2),len,nFFT,len2,(win));

min_mat=zeros(nFFT/2+1,floor(0.8*Srate/(Nframes/2)));

%% Start processing
%
SNRseg = zeros(Nframes,1);
SNRsegReal = zeros(Nframes,1);
MSE = zeros(Nframes,1);

for n = 1:Nframes 
    %------ channel 1
    insign1 = x(k:k+len-1,1).*win;           % noisy speech
    cl_sign1 = cl(k:k+len-1,1).*win;         % clean speech
    tn1 = insign1 - cl_sign1;                % noise signal
    noise_sign1 = noise(k:k+len-1,1).*win;   % noise_signal    
    
    %--- Take fourier transform of  signals
    
    spec1 = fft(insign1,nFFT);   
    sig1 = abs(spec1); % compute the magnitude of noisy speech
    sig2_1 = sig1.^2;
    theta_1 = angle(spec1);    
    
    cl_spec1 = fft(cl_sign1,nFFT);   
    cl_sig1 = abs(cl_spec1); % compute the magnitude of clean signal
    cl_sig2_1 = cl_sig1.^2;
    
    
    tn_spec1 = fft(tn1,nFFT);   
    tn_sig1 = abs(tn_spec1); % compute the magnitude of masker
    tn_sig2_1 = tn_sig1.^2;
    
    noisesign_spec1 = fft(noise_sign1,nFFT);
    noise_sign_mag1 = abs(noisesign_spec1);
    noise_sign_mag2_1 = noise_sign_mag1.^2;

    %%
    %------ channel 2
    insign2 = x(k:k+len-1,2).*win;           % noisy speech
    cl_sign2 = cl(k:k+len-1,2).*win;         % clean speech
    tn2 = insign2 - cl_sign2;                % noise signal
    noise_sign2 = noise(k:k+len-1,2).*win;   % noise_signal

    %--- Take fourier transform of  signals
    
    spec2 = fft(insign2,nFFT);   
    sig2 = abs(spec2); % compute the magnitude of noisy speech
    sig2_2 = sig2.^2;
    theta_2 = angle(spec2);    
    
    cl_spec2 = fft(cl_sign2,nFFT);   
    cl_sig2 = abs(cl_spec2); % compute the magnitude of clean signal
    cl_sig2_2 = cl_sig2.^2;
    
    
    tn_spec2 = fft(tn2,nFFT);   
    tn_sig2 = abs(tn_spec2); % compute the magnitude of masker
    tn_sig2_2 = tn_sig2.^2;
    
    noisesign_spec2 = fft(noise_sign2,nFFT);
    noise_sign_mag2 = abs(noisesign_spec2);
    noise_sign_mag2_2 = noise_sign_mag2.^2;
    
    %% Estimate noise spectrum (channel 1)

    % use noise estimation algorithm
    if n==1
        parameters1 = initialise_parameters(noise_initial1,Srate,method,...
            noise_psd1,n,min_mat,Nframes);
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
    if n==1
        parameters2 = initialise_parameters(noise_initial2,Srate,method,...
            noise_psd2,n,min_mat,Nframes);
        parameters2 = noise_estimation(noise_initial2, method, parameters2); 
    else
       parameters2 = noise_estimation(sig2_2, method, parameters2); 
    end
    noise_mu2_2 = parameters2.noise_ps;
    noise_mu_2 = sqrt(noise_mu2_2);         % magnitude spectrum    
    
    noise_mu2_2 = mean(noise_mu2_2,2);      % get average of last frames
    noise_mu_2 = mean(noise_mu_2,2);        % get average of last frames
    
    
    %% Compare which signal has the highest SNR (lowest noise power)
    
    % Compare on a average bin values base
    if (mean(noise_mu2_1) < mean(noise_mu2_2))
        %% SNR and MSE estimation
%         % 1. SNR estimation 
%         SNRseg(n) = log10(sum((sig2_1-noise_mu2_1).^2)./sum((noise_mu2_1).^2)); % Obtain SNR estim.
%         % Eliminate inf values(because signal is filled with zeros - only happens at conn-freq algorithm)
%         % SNRseg = SNRseg(isfinite(SNRseg));
%     
%         % 2. SNR real
%         % SNRsegReal(n) = log10(sum((sig2-noise_sign_mag2).^2)./sum((noise_sign_mag2).^2)); % Obtain SNR real
%         SNRsegReal(n) = log10(sum((sig2_1-tn_sig2_1).^2)./sum((tn_sig2_1).^2)); % Obtain SNR real
%         
%         % 3. Normalized distance estimation
%         MSE(n)=sum((noise_mu_1-sig1).^2)/nFFT;%Distance_normalized
%     
%         %% Compare variance of estimated noise signal and real noise signal
%         sigEstNoise = sum(noise_mu2_1)/nFFT;
%         sigRelNoise = sum(tn_sig2_1)/nFFT;
%     
%         %% Compare variance of real clean signal and difenrence between noyse and est. noise
%         sigEstClean = sum(cl_sig2_1)/nFFT;
%         sigRelEstClean = sum(sig2_1 - noise_mu2_1)/nFFT;    
        %%       
        gammak = min(sig2_1./noise_mu2_1,20);
        if n==1
        
            ksi2 = aa+(1-aa)*max(gammak-1,0);
            ksi2 = max(ksi2,0.0025);
        
        else   
            ksi2 = aa*Xk_prev./noise_mu2_1 + (1-aa)*max(gammak-1,0); % Traditional a priori SNR in MMSE                    
            ksi2 = max(ksi2,0.0025);
        end
 
   
        %% COMPUTE GAIN FUNCTION
        %
        switch GAIN
            case 'Wiener' % Wiener filter as per Scalart ...
            
                %x_hw = sqrt(ksi2 ./(ksi2+1));  
                x_hw = (ksi2 ./(ksi2+1));  
       
            case 'SpecSub'  % Basic spectral subtraction
           
                x_hw = sqrt(max(0,(gammak-1)./gammak));  
                   
            case {'MMSE', 'MMSE-SPU'}  %--- MMSE function
           
                vk=ksi2.*gammak./(1+ksi2);
                %[j0,err]=besseli(0,vk/2);
                [j0]=besseli(0,vk/2);
                %[j1,err2]=besseli(1,vk/2);
                [j1]=besseli(1,vk/2);
                %if any(err) | any(err2)
                %    fprintf('ERROR! Overflow in Bessel calculation in frame: %d \n',n);
                %else
                C=exp(-0.5*vk);
                A=((c*(vk.^0.5)).*C)./gammak;
                B=(1+vk).*j0+vk.*j1;
                x_hw=A.*B;
                %end

                qk=0.3;   % include speech-presence uncertainty
                qkr=(1-qk)/qk;
                evk=exp(vk);
                Lambda=qkr*evk./(1+ksi2);
                pSAP=Lambda./(1+Lambda);
       
            case 'pMMSE'  %  Weighted euclidean Bayesian estimator - Loizou, 2005
           
                vk=ksi2.*gammak./(1+ksi2);
                x_hw=CC*sqrt(vk)./(gammak.*exp(-vk/2).*besseli(0,vk/2)); 
       
            case 'logMMSE' % Log-MMSE estimator
           
                A=ksi2./(1+ksi2);  
                vk=A.*gammak;
                ei_vk=0.5*expint(vk);
                x_hw=A.*exp(ei_vk);

            otherwise
           
                error('ERROR! Not a valid gain function');
                   
        end
    
    
        %% SAVE Enhanced magnitude for ksi estimation

        x_sig = sig1.*x_hw;   
        if strcmp(GAIN,'MMSE-SPU')
            x_sig = x_sig.*pSAP;
        end 
        Xk_prev = x_sig.^2;
    
       
        %% ========== Constraint magnitude rule =====================
    
        rpp = find(x_sig<2*cl_sig1);  % Region I+II rule
        %rpp = find(x_sig<cl_sig);  % Region I rule
        hw_residual = zeros(len,1);
        hw_residual(rpp)=1;
        hw_residual(1) = 1; hw_residual(nFFT2+1)=1;
     

        %%    Synthesize signal
    

        x_hw_new = x_hw .* hw_residual;
        % x_hw_new = hw_residual;
        % x_hw_new = x_hw;   % use Wiener gain function (all channels)
        xi_w = ifft(x_hw_new .* spec1);    % enhance signal using Gain function  
        xi_w = real( xi_w);
	
        % --- Overlap and add ---------------
        
        xfinal(k:k+ len1-1) = x_old+ xi_w(1:len1);
        x_old = xi_w(len2+ 1: len);

        k = k+len2;

    else        
        %% SNR and MSE estimation
        % 1. SNR estimation 
%         SNRseg(n) = log10(sum((sig2_2-noise_mu2_2).^2)./sum((noise_mu2_2).^2)); % Obtain SNR estim.
%         % Eliminate inf values(because signal is filled with zeros - only happens at conn-freq algorithm)
%         % SNRseg = SNRseg(isfinite(SNRseg));
%     
%         % 2. SNR real
%         % SNRsegReal(n) = log10(sum((sig2-noise_sign_mag2).^2)./sum((noise_sign_mag2).^2)); % Obtain SNR real
%         SNRsegReal(n) = log10(sum((sig2_2-tn_sig2_2).^2)./sum((tn_sig2_2).^2)); % Obtain SNR real
%         
%         % 3. Normalized distance estimation
%         MSE(n)=sum((noise_mu_2-sig2).^2)/nFFT;%Distance_normalized
%     
%         %% Compare variance of estimated noise signal and real noise signal
%         sigEstNoise = sum(noise_mu2_2)/nFFT;
%         sigRelNoise = sum(tn_sig2_2)/nFFT;
%     
%         %% Compare variance of real clean signal and difenrence between noyse and est. noise
%         sigEstClean = sum(cl_sig2_2)/nFFT;
%         sigRelEstClean = sum(sig2_2 - noise_mu2_2)/nFFT;    
        %%       
        gammak = min(sig2_2./noise_mu2_2,20);
        if n==1
        
            ksi2 = aa+(1-aa)*max(gammak-1,0);
            ksi2 = max(ksi2,0.0025);
        
        else   
            ksi2 = aa*Xk_prev./noise_mu2_2 + (1-aa)*max(gammak-1,0); % Traditional a priori SNR in MMSE                    
            ksi2 = max(ksi2,0.0025);
        end
 
   
        %% COMPUTE GAIN FUNCTION
        %
        switch GAIN
            case 'Wiener' % Wiener filter as per Scalart ...
            
                %x_hw = sqrt(ksi2 ./(ksi2+1));
                x_hw = (ksi2 ./(ksi2+1));  
       
            case 'SpecSub'  % Basic spectral subtraction
           
                x_hw = sqrt(max(0,(gammak-1)./gammak));  
                   
            case {'MMSE', 'MMSE-SPU'}  %--- MMSE function
           
                vk=ksi2.*gammak./(1+ksi2);
                %[j0,err]=besseli(0,vk/2);
                [j0]=besseli(0,vk/2);
                %[j1,err2]=besseli(1,vk/2);
                [j1]=besseli(1,vk/2);
                %if any(err) | any(err2)
                %    fprintf('ERROR! Overflow in Bessel calculation in frame: %d \n',n);
                %else
                C=exp(-0.5*vk);
                A=((c*(vk.^0.5)).*C)./gammak;
                B=(1+vk).*j0+vk.*j1;
                x_hw=A.*B;
                %end

                qk=0.3;   % include speech-presence uncertainty
                qkr=(1-qk)/qk;
                evk=exp(vk);
                Lambda=qkr*evk./(1+ksi2);
                pSAP=Lambda./(1+Lambda);
       
            case 'pMMSE'  %  Weighted euclidean Bayesian estimator - Loizou, 2005
           
                vk=ksi2.*gammak./(1+ksi2);
                x_hw=CC*sqrt(vk)./(gammak.*exp(-vk/2).*besseli(0,vk/2)); 
       
            case 'logMMSE' % Log-MMSE estimator
           
                A=ksi2./(1+ksi2);  
                vk=A.*gammak;
                ei_vk=0.5*expint(vk);
                x_hw=A.*exp(ei_vk);

            otherwise
           
                error('ERROR! Not a valid gain function');
                   
        end
    
    
        %% SAVE Enhanced magnitude for ksi estimation

        x_sig = sig2.*x_hw;   
        if strcmp(GAIN,'MMSE-SPU')
            x_sig=x_sig.*pSAP;
        end 
        Xk_prev = x_sig.^2;
    
       
        %% ========== Constraint magnitude rule =====================
    
        rpp = find(x_sig<2*cl_sig2);  % Region I+II rule
        %rpp = find(x_sig<cl_sig);  % Region I rule
        hw_residual= zeros(len,1);
        hw_residual(rpp)=1;
        hw_residual(1)=1; hw_residual(nFFT2+1)=1;
     

        %%    Synthesize signal
    

        x_hw_new = x_hw .* hw_residual;
        % x_hw_new = hw_residual;
        % x_hw_new = x_hw;   % use Wiener gain function (all channels)
        xi_w = ifft(x_hw_new .* spec2);    % enhance signal using Gain function  
        xi_w = real( xi_w);
	
        % --- Overlap and add ---------------
        
        xfinal(k:k+ len1-1) = x_old+ xi_w(1:len1);
        x_old = xi_w(len2+ 1: len);

        k = k+len2;

    end

end

%% Get average SNR and MSE estimation
%SNREst = mean(SNRseg);
% SNREst = (10/Nframes).*sum(SNRseg);
% SNRReal = (10/Nframes).*sum(SNRsegReal);
% MSEAvg = sum(MSE)/Nframes;
% 
% %% Estimated and real noise variance
% sigEstNoise = sum(sigEstNoise)/Nframes;
% sigRelNoise = sum(sigRelNoise)/Nframes;
% 
% sigEstClean = sum(sigEstClean)/Nframes;
% sigRelEstClean = sum(sigRelEstClean)/Nframes;  

%% -----------------------
SNREst = 0;
SNRReal = 0;
MSEAvg = 0;

%% Estimated and real noise variance
sigEstNoise = 0;
sigRelNoise = 0;

sigEstClean = 0;
sigRelEstClean = 0;  

%%  =======================================================================
 

if max(abs(xfinal))>1
   xfinal = xfinal*0.6/max(abs(xfinal));
%    fprintf('Max amplitude exceeded 1 for file %s\n',filename);   
end

% audiowrite(outfile,xfinal,fs)
% wavwrite(xfinal,Srate,16,outfile);

