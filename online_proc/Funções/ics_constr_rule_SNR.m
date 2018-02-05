function  [SNREst, SNRReal, MSEAvg, sigEstNoise, sigRelNoise, sigEstClean, sigRelEstClean, SNRprio, SNRpost, SNRprioRe, SNRpostRe, xfinal] = ics_constr_rule_SNR(x, cl, noise, Srate, outfile, GAIN, method, SNREstAl)
% function  [SNREst, SNRReal, MSEAvg, sigEstNoise, sigRelNoise, sigEstClean, sigRelEstClean, SNRprio, SNRpost, SNRprioRe, SNRpostRe, xfinal] = ics_constr_rule_SNR(x, cl, noise, Srate, outfile, GAIN, method, SNREstAl)
% Input
%   x                 -   noisy speech filename (mixture)
%   cl                -   clean speech filename
%   noise             -   noise signal filename
%   Srate             -   sampling rate
%   outilfe           -   name of output file
%   GAIN      -   'Wiener'; 'MMSE', 'logMMSE', 'MMSE-SPU'; 'pMMSE'; 'SpecSub'
%   method            -   Algorithm of PSD noise estimation 
%   SNREstAl          -   Algorithm of SNR estimation
% Output
%   SNREst            -   SNR estimated
%   SNRReal           -   SNR measured
%   MSEAvg            -   Normalized distance
%   sigEstNoise       -   Average power of estimated noise
%   sigRelNoise       -   Average power of measured noise
%   sigEstClean       -   Average power of measured clean speech
%   sigRelEstClean    -   Average power of estimated (Y - V)
%   SNRprio           -   SNR a priori
%   SNRpost           -   SNR a posteriori
%   xfinal            -   Filtered signal
%
%  Updated Sept 26, 2011 - corrected windowing (PL)
%
%  Copyright (c) 2011 by Philipos C. Loizou


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

% win = hanning(len); 
% win = hanning(512); 

% Noise magnitude calculations - assuming that the first 4 frames is
% noise/silence
% nFFT = len;
% nFFT = 512;


%%
% =============== Initialize variables / Parameters ===============
overlap = 0.50;                                  % window overlap 
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

noise_mean=zeros(nFFT,1);
j=1;
for k=1:4
   magn=abs(fft(win.*x(j:j+len-1),nFFT)).^2;
   noise_mean=noise_mean+magn;
   j=j+len;
end
noise_initial=noise_mean/4;
%%

%--- allocate memory and initialize various variables
   
k = 1;
x_old = zeros(len1,1);
% Nframes = floor(length(x)/len2)-1;
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

news = zeros(length(x),1);

%% ===========  used mmsepsd_estimation   ============
% noise_psd = init_noise_tracker_ideal_vad(x,len,nFFT,len2,...
%     sqrt(win)); % This function computes the initial noise PSD estimate. It is assumed
% % that the first 5 time-frames are noise-only.

noise_psd = init_noise_tracker_ideal_vad(x,len,nFFT,len2,...
    (win)); % This function computes the initial noise PSD estimate. It is assumed
% that the first 5 time-frames are noise-only.

min_mat=zeros(nFFT/2+1,floor(0.8*Srate/(Nframes/2)));

%% Start processing
%
SNRseg = zeros(Nframes,1);
SNRsegReal = zeros(Nframes,1);
MSE = zeros(Nframes,1);

SNRpost   = zeros(Nframes,1);
SNRprio   = zeros(Nframes,1);
SNRpostRe = zeros(Nframes,1);
SNRprioRe = zeros(Nframes,1);

for n = 1:Nframes 
    insign = x(k:k+len-1).*win;           % noisy speech
    cl_sign =cl(k:k+len-1).*win;          % clean speech
    tn = insign - cl_sign;                % noise signal
    noise_sign = noise(k:k+len-1).*win;   % noise_signal
    
    %--- Take fourier transform of  signals
    
    spec = fft(insign,nFFT);   
    sig = abs(spec); % compute the magnitude of noisy speech
    sig2 = sig.^2;
    theta = angle(spec);    
    
    cl_spec = fft(cl_sign,nFFT);   
    cl_sig = abs(cl_spec); % compute the magnitude of clean signal
    cl_sig2 = cl_sig.^2;
    
    
    tn_spec = fft(tn,nFFT);   
    tn_sig = abs(tn_spec); % compute the magnitude of masker
    tn_sig2 = tn_sig.^2;
    
    noisesign_spec = fft(noise_sign,nFFT);
    noise_sign_mag = abs(noisesign_spec);
    noise_sign_mag2 = noise_sign_mag.^2;
    
%% Estimate noise spectrum
%
 % use noise estimation algorithm
    if n==1
        parameters = initialise_parameters(noise_initial,Srate,method,...
            noise_psd,n,min_mat,Nframes);
        parameters = noise_estimation(noise_initial, method, parameters); 
    else
       parameters = noise_estimation(sig2, method, parameters); 
    end
    noise_mu2 = parameters.noise_ps;
    noise_mu = sqrt(noise_mu2);         % magnitude spectrum    
    
    noise_mu2 = mean(noise_mu2,2);      % get average of last frames
    noise_mu = mean(noise_mu,2);        % get average of last frames
    %% SNR and MSE estimation
    % 1. SNR estimation 
%     SNRseg(n) = log10(sum((sig2-noise_mu2).^2)./sum((noise_mu2).^2)); % Obtain SNR estim.
%     % Eliminate inf values(because signal is filled with zeros - only happens at conn-freq algorithm)
%     % SNRseg = SNRseg(isfinite(SNRseg));
%     
%     % 2. SNR real
%     % SNRsegReal(n) = log10(sum((sig2-noise_sign_mag2).^2)./sum((noise_sign_mag2).^2)); % Obtain SNR real
%     SNRsegReal(n) = log10(sum((sig2-tn_sig2).^2)./sum((tn_sig2).^2)); % Obtain SNR real
%         
%     % 3. Normalized distance estimation
%     MSE(n)=sum((noise_mu-sig).^2)/nFFT;%Distance_normalized
%     
%     %% Compare variance of estimated noise signal and real noise signal
%     sigEstNoise = sum(noise_mu2)/nFFT;
%     sigRelNoise = sum(tn_sig2)/nFFT;
%     
%     %% Compare variance of real clean signal and difenrence between noyse and est. noise
%     sigEstClean = sum(cl_sig2)/nFFT;
%     sigRelEstClean = sum(sig2 - noise_mu2)/nFFT;    


%%  SNR estimation algorithms
    switch SNREstAl
        case 'Cappe'
            
            gammak = min(sig2./noise_mu2,20);
            if n==1
        
                ksi2 = aa+(1-aa)*max(gammak-1,0);
                ksi2 = max(ksi2,0.0025);
    
            else   
                ksi2 = aa*Xk_prev./noise_mu2 + (1-aa)*max(gammak-1,0); % Traditional a priori SNR in MMSE                    
                ksi2 = max(ksi2,0.0025);
            end
            
        case 'TSNR'
            
            magy = sig;
            if n==1 
                
%                 postsnr = ((magy.^2) ./ noise_mu2)-1 ;  % a posteriori SNR
%                 postsnr = max(postsnr,0.1);  % limitation to prevent distorsion 
                
                postsnr = min(sig2./noise_mu2,20);
                
                %calculate a priori SNR using decision directed approach
                eta = aa + (1-aa) * postsnr;
                newmag = (eta./(eta+1)).*  magy;
            
                %calculate TSNR
                tsnr = (newmag.^2) ./ noise_mu2;
            
                % finaly, a priori and a posteriori snr
                gammak = postsnr;
                ksi2 = tsnr;                
                
            else
                
%                 postsnr = ((magy.^2) ./ noise_mu2)-1 ;  % a posteriori SNR
%                 postsnr = max(postsnr,0.1);  % limitation to prevent distorsion 
                
                postsnr = min(sig2./noise_mu2,20);
                
                %calculate a priori SNR using decision directed approach
                eta = aa*Xk_prev./noise_mu2 + (1-aa) * postsnr;
                newmag = (eta./(eta+1)).*  magy;
            
                %calculate TSNR
                tsnr = (newmag.^2) ./ noise_mu2;
            
                % finaly, a priori and a posteriori snr
                gammak = postsnr;
                ksi2 = tsnr;
            end
        case 'HRNR'
            
            magy = sig;
            phasey = angle(spec);         %extract phase

            if n==1 
                
                %postsnr = ((magy.^2) ./ noise_mu2)-1 ;  % a posteriori SNR
                %postsnr = max(postsnr,0.1);  % limitation to prevent distorsion 
                
                postsnr = min(sig2./noise_mu2,20);
                
                %calculate a priori SNR using decision directed approach
                eta = aa + (1-aa) * postsnr;
                newmag = (eta./(eta+1)).*  magy;
            
                %calculate TSNR
                tsnr = (newmag.^2) ./ noise_mu2;
                
                % Gain of TSNR
                Gtsnr = tsnr ./ (tsnr+1);
                tsnra(:,n) = Gtsnr;
                
                newmag = Gtsnr .* magy;
                newmags(:,n) = newmag;     %for HRNR use
                ffty = newmag.*exp(1i*phasey);
                news(k:k+len-1) = news(k:k+len-1) +...
                    real(ifft(ffty,nFFT))/(1/overlap);

                esTSNR = news;
                
                % non linearity
                newharm= max(esTSNR,0);
                
                nharm = win.*newharm(k:k+len-1);
                ffth = abs(fft(nharm,nFFT));          %perform fast fourier transform
                
                snrham= ( (tsnra(:,n)).*(abs(newmags(:,n)).^2) +...
                    (1-(tsnra(:,n))) .* (ffth.^2) ) ./noise_mu2;


                
                % finaly, a priori and a posteriori snr
                gammak = postsnr;
                ksi2 = snrham;                
                
            else
                
                %postsnr = ((magy.^2) ./ noise_mu2)-1 ;  % a posteriori SNR
                %postsnr = max(postsnr,0.1);  % limitation to prevent distorsion 
                
                postsnr = min(sig2./noise_mu2,20);
                
                %calculate a priori SNR using decision directed approach
                eta = aa*Xk_prev./noise_mu2 + (1-aa) * postsnr;
                newmag = (eta./(eta+1)).*  magy;
            
                %calculate TSNR
                tsnr = (newmag.^2) ./ noise_mu2;
            
                % Gain of TSNR
                Gtsnr = tsnr ./ (tsnr+1);
                tsnra(:,n) = Gtsnr;
                
                newmag = Gtsnr .* magy;
                newmags(:,n) = newmag;     %for HRNR use
                ffty = newmag.*exp(1i*phasey);
                news(k:k+len-1) = news(k:k+len-1) +...
                    real(ifft(ffty,nFFT))/(1/overlap);

                esTSNR = news;
                
                % non linearity
                newharm= max(esTSNR,0);
                
                nharm = win.*newharm(k:k+len-1);
                ffth = abs(fft(nharm,nFFT));          %perform fast fourier transform
                
                snrham= ( (tsnra(:,n)).*(abs(newmags(:,n)).^2) +...
                    (1-(tsnra(:,n))) .* (ffth.^2) ) ./noise_mu2;


                
                % finaly, a priori and a posteriori snr
                gammak = postsnr;
                ksi2 = snrham;                
                
            end            
              
    end
   
%% SNR posteriori and priori
    SNRpost(n) = sum(gammak(1:len1,:))/nFFT;        % Estimated
    SNRprio(n) = sum(ksi2(1:len1,:))/nFFT;          % Estimated
    
    gammakRe = min(sig2./noise_sign_mag2,20);       % Real
    SNRpostRe(n) = sum(gammakRe(1:len1,:))/nFFT;    
    ksi2Re = cl_sig2./noise_sign_mag2;              % Real
    SNRprioRe(n) = sum(ksi2Re(1:len1,:))/nFFT;
    
    
%% COMPUTE GAIN FUNCTION
%
   switch GAIN
       case 'Wiener' % Wiener filter as per Scalart ...
            
           x_hw = sqrt(ksi2 ./(ksi2+1));  
%            x_hw = (ksi2 ./(ksi2+1));  
       
       case 'SpecSub'  % Basic spectral subtraction
           
           x_hw = sqrt(max(0,(gammak-1)./gammak));  
                   
       case {'MMSE', 'MMSE-SPU'}  %--- MMSE function
           
           vk=ksi2.*gammak./(1+ksi2);
           %[j0,err]=besseli(0,vk/2);
           [j0]=besseli(0,vk/2);
           %[j1,err2]=besseli(1,vk/2);
           [j1]=besseli(1,vk/2);
%            if any(err) | any(err2)
%                fprintf('ERROR! Overflow in Bessel calculation in frame: %d \n',n);
%            else
               C=exp(-0.5*vk);
               A=((c*(vk.^0.5)).*C)./gammak;
               B=(1+vk).*j0+vk.*j1;
               x_hw=A.*B;
%            end

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

    x_sig = sig.*x_hw;   
    if strcmp(GAIN,'MMSE-SPU')
        x_sig=x_sig.*pSAP;
    end 
    Xk_prev = x_sig.^2;
    
       
    %% ========== Constraint magnitude rule =====================
    %
    rpp = find(x_sig<2*cl_sig);  % Region I+II rule
    %rpp = find(x_sig<cl_sig);  % Region I rule
    hw_residual= zeros(len,1);
    hw_residual(rpp)=1;
    hw_residual(1)=1; hw_residual(nFFT2+1)=1;
     

%%    Synthesize signal
%
    x_hw_new = x_hw .* hw_residual;
    % x_hw_new = hw_residual;
    % x_hw_new = x_hw;   % use Wiener gain function (all channels)
    xi_w = ifft(x_hw_new .* spec);    % enhance signal using Gain function  
    xi_w = real( xi_w);
	
    % --- Overlap and add ---------------
    %
    xfinal(k:k+ len1-1) = x_old+ xi_w(1:len1);
    x_old = xi_w(len2+ 1: len);

   
    k = k+len2;
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

%% ----------------------------------------------

SNREst = 0;
SNRReal = 0;
MSEAvg = 0;

%% Estimated and real noise variance
sigEstNoise = 0;
sigRelNoise = 0;

sigEstClean = 0;
sigRelEstClean = 0;


%% SNR a priori and a posteriori
SNRpost = 10*log10(sum(SNRpost)/Nframes);
SNRprio = 10*log10(sum(SNRprio)/Nframes);
SNRpostRe = 10*log10(sum(SNRpostRe)/Nframes);
SNRprioRe = 10*log10(sum(SNRprioRe)/Nframes);

%%  =======================================================================
 

if max(abs(xfinal))>1
   xfinal = xfinal*0.6/max(abs(xfinal));
   fprintf('Max amplitude exceeded 1 for file %s\n',filename);   
end

% sound(xfinal,16000)
% wavwrite(xfinal,Srate,16,outfile);

