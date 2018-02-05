function lambda_n = npsd_rs(x,rfs,overlap)
% Noise power spectral density estimation based on regional statistics (RS)
% Input:
%   x: single channel noisy speech signal
%   rfs: sampling frequecy of x
%   overlap: 0.5, 50% overlap in STFT, defult
%            0.75, 75% overlap 
%   
% Output: 
%   lambda_n(k,l): estimated noise psd with frequecy index of k and frame index of l
%   
% Author: Xiaofei Li, INRIA Grenoble Rhone-Alpes
% Copyright: Perception Team, INRIA Grenoble Rhone-Alpes
% The algorithm is described in the paper:  
% X. Li, L. Girin, S. Gannot and R. Horaud. Non-stationary Noise Power Spectral Density Estimation based on 
% Regional Statistics. ICASSP, 2016. 

if nargin<3
    overlap = 0.5;
end

% Parameters
fs = 16000;                   % Reference sampling frequecy 
winLen = 128;                 % Size of STFT analysis window, it can be reset by the user
fraShi = round(winLen*(1-overlap));  % Frame shift for consecutive frames (len2)
win = hamming(winLen);        % Analysis window
freRan = 1:winLen/2;          % Frequency range to be considered
freNum = length(freRan);      % Frequency number (len1)
fraNum = fix((length(x)-winLen)/fraShi+1);   % Frame number (Nframes)

if overlap == 0.75
    alpha_n = 0.9;            % Parameter to set the time-varying nosie psd updating parameter
    alpha_x = 0.92;           % Smoothing parameter to compute regional statistics 
                              % It is equivalent to a smoothing window with the length of 0.2s 
    thetaMean = [0.7100  0.8804  0.4437  0.3636]';   % Expectation vector of the regional statistics for noise-only signal 
    Sigma = diag([0.0937  0.1382  0.0345  0.0082]);  % Covariance matrix of the regional statistics for noise-only signal 
                                                     % Expectation vector and Covariance matrix are inferred from white Gaussian noise
else
    alpha_n = 0.8;                
    alpha_x = 0.85;           % It is equivalent to a smoothing window with the length of 0.2s  
    
    thetaMean = [0.6002  1.4655  0.2575  0.5043]';   
    Sigma = diag([0.0640  0.5406  0.0120  0.0192]);                                                  
end

SigmaInv = inv(Sigma);

delta1 = 4;  %                  
delta2 = 8;  % Parameters to compute speech presence probability                              

% Resampling niosy speech signal
if rfs~=fs
    x = resample(x,fs,rfs);
end

% Variables
periodograms = zeros(freNum,fraNum);        % Periodograms 
Pkl = zeros(freNum,fraNum);                 % Smoothed Periodograms
dkl = zeros(freNum,fraNum);                 % Normalized distance between regional statistics of noisy signal and Expectation vector
dklSmo = zeros(freNum,fraNum);              % Smoothed normalized distance
pkl = zeros(freNum,fraNum);                 % Speech presence probability
lambda_n = zeros(freNum,fraNum);            % Noise psd

% Estimate noise psd frame by frame
waitHandle=waitbar(0,'Please wait...');
for l = 1:fraNum
    xl = x((l-1)*fraShi+1:(l-1)*fraShi+winLen);  % The lth frame signal in time domain    
    Xkl = fft(xl.*win);                          % FFT
    Xkl2 = abs(Xkl(freRan)).^2;                  % Periodograms        
    periodograms(:,l) = Xkl2;    
    
    % Initialization at the first frame
    if l==1
        Pkl(:,l) = Xkl2;
        pkl(:,l) = zeros(freNum,1);
        lambda_n(:,l) = Xkl2; 
        theta_nv = thetaMean(1);      % Normalized Variance         
        theta_ndv = thetaMean(2);     % Normalized Differential Variance
        theta_nav = thetaMean(3);     % Normalized Average Variance
        theta_mcr = thetaMean(4);     % Median Crossing   
        continue;
    end
    
    % Smooth periodograms
    Pkl(:,l) = alpha_x*Pkl(:,l-1)+(1-alpha_x)*Xkl2;  
    
    % Recursively update regional statistics
    theta_nv = alpha_x*theta_nv+(1-alpha_x)*(Xkl2-Pkl(:,l)).^2./Pkl(:,l).^2;    
    theta_ndv = alpha_x*theta_ndv+(1-alpha_x)*(Xkl2-periodograms(:,l-1)).^2./Pkl(:,l).^2;   
    theta_nav = alpha_x*theta_nav+(1-alpha_x)*((Xkl2+periodograms(:,l-1))/2-Pkl(:,l)).^2./Pkl(:,l).^2;
    
    mcInd = (((Xkl2-0.69*Pkl(:,l))>0) - ((periodograms(:,l-1)-0.69*Pkl(:,l-1))>0)) ~= 0;
    theta_mcr = alpha_x*theta_mcr+(1-alpha_x)*mcInd;
    
    % Regional statistics vector
    theta = [theta_nv,theta_ndv,theta_nav,theta_mcr];    
    
    % Normalized distance 
    dkl(:,l) = diag((bsxfun(@minus,theta,thetaMean'))*SigmaInv*(bsxfun(@minus,theta,thetaMean'))');
    
    % Smooth normalized distance in the frame range of [l-3,l] and frequecy range of [k-1,k+1]
    if l>3
        dklSet = [dkl(:,l-3:l),[dkl(1,l-3:l);dkl(1:freNum-1,l-3:l)],[dkl(2:freNum,l-3:l);dkl(freNum,l-3:l)]];
    else
        dklSet = [dkl(:,1:l),[dkl(1,1:l);dkl(1:freNum-1,1:l)],[dkl(2:freNum,1:l);dkl(freNum,1:l)]];
    end
    dklSmo(:,l) = mean(dklSet,2);  % Smoothed normalized distance
    
    % Compute speech presence probability
    dklSmo12 = delta1*(dklSmo(:,l)<=delta1) + delta2*(dklSmo(:,l)>=delta2) + dklSmo(:,l).*(dklSmo(:,l)>delta1 & dklSmo(:,l)<delta2);
    pkl(:,l) = (Xkl2<9.2*lambda_n(:,l-1)).*(dklSmo12-delta1)/(delta2-delta1);
    pkl(:,l) = pkl(:,l)+(dklSmo(:,l)>delta1).*(Xkl2>=9.2*lambda_n(:,l-1));
    pkl(:,l) = pkl(:,l).*(Pkl(:,l)>lambda_n(:,l-1));     % Speech presence probability  
    
    % Compute time-varying smoothing parameter and recursively update noise psd estimation
    alphaSpp_n = alpha_n+(1-alpha_n)*pkl(:,l);   
    lambda_n(:,l) = alphaSpp_n.*lambda_n(:,l-1)+(1-alphaSpp_n).*Xkl2;
   
    waitbar(l/fraNum);
end
close(waitHandle)


