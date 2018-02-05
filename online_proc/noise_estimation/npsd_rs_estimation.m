function [parameters] = npsd_rs_estimation(ns_ps,parameters)
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

%         parameters = struct('n',2,'alpha_n',alpha_n,'alpha_x',alpha_x,...
%             'thetaMean',thetaMean,'SigmaInv',SigmaInv,...
%             'delta1',delta1,'delta2',delta2,'noise_psd',noise_psd,...
%             'noise_ps',noise_ps,'pkl',pkl,'Pkl',Pkl,'theta_nv',...
%             theta_nv,'theta_ndv',theta_ndv,'theta_nav',theta_nav,...
%             'theta_mcr',theta_mcr,'dkl',dkl,'dklSmo',dklSmo,...
%             'periodograms',periodograms);


n = parameters.n;
alpha_n = parameters.alpha_n;
alpha_x = parameters.alpha_x;
thetaMean = parameters.thetaMean;
SigmaInv = parameters.SigmaInv;
delta1 = parameters.delta1;
delta2 = parameters.delta2;
lambda_n = parameters.noise_ps;
pkl = parameters.pkl;
Pkl = parameters.Pkl;
theta_nv = parameters.theta_nv;
theta_ndv = parameters.theta_ndv;
theta_nav = parameters.theta_nav;
theta_mcr = parameters.theta_mcr;
dkl = parameters.dkl;
dklSmo = parameters.dklSmo;
periodograms = parameters.periodograms;

freNum = length(ns_ps);

% ns_ps = parameters.ns_ps;

Xkl2 = ns_ps;            % Periodograms        

l = n;
               
periodograms(:,l) = Xkl2;    
    
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

    

    
    
parameters.n = n+1;
parameters.alpha_n = alpha_n;
parameters.alpha_x = alpha_x;
parameters.thetaMean = thetaMean;
parameters.SigmaInv = SigmaInv;
parameters.delta1 = delta1;
parameters.delta2 = delta2;
parameters.noise_ps = lambda_n;
parameters.pkl = pkl;
parameters.Pkl = Pkl;
parameters.theta_nv = theta_nv;
parameters.theta_ndv = theta_ndv;
parameters.theta_nav = theta_nav;
parameters.theta_mcr = theta_mcr;
parameters.dkl = dkl;
parameters.dklSmo = dklSmo;
parameters.periodograms = periodograms;

% parameters.ns_ps = ns_ps;

