function parameters = initialise_parameters(ns_ps,Srate,method,noise_psd,nFrame,min_mat,Nframes)
len_val = length(ns_ps);
switch lower(method)
    case 'martin'
        L_val=len_val; 
        R_val=len_val/2; 
        D_val=150; V_val=15; Um_val=10; Av_val=2.12; 
        alpha_max_val=0.96; 
        alpha_min_val=0.3; 
        beta_max_val=0.8;
        x_val=[1 2 5 8 10 15 20 30 40 60 80 120 140 160];
        Y_M_val=[0 .26 .48 .58 .61 .668 .705 .762 .8 .841 .865 .89 .9 .91];
        Y_H_val=[0 .15 .48 .78 .98 1.55 2.0 2.3 2.52 2.9 3.25 4.0 4.1 4.1];
        xi_val=D_val;
        M_D_val=interp1(x_val,Y_M_val,xi_val);
        H_D_val=interp1(x_val,Y_H_val,xi_val);
        xi_val=V_val;
        M_V_val=interp1(x_val,Y_M_val,xi_val);
        H_V_val=interp1(x_val,Y_H_val,xi_val);
        minact_val(1:L_val,1:Um_val)=max(ns_ps);
        parameters = struct('n',2,'len',len_val,'alpha_corr',0.96,'alpha',0.96*ones(len_val,1),'P',ns_ps,'noise_ps',ns_ps,'Pbar',ns_ps,...
            'Psqbar',ns_ps,'actmin',ns_ps,'actmin_sub',ns_ps,'Pmin_u',ns_ps,'subwc',2,'u',1,'minact',minact_val,'lmin_flag',zeros(len_val,1),...
            'L',L_val,'R',R_val,'D',D_val,'V',V_val,'Um',Um_val,'Av',Av_val,'alpha_max',alpha_max_val,'alpha_min',alpha_min_val,...
            'beta_max',beta_max_val,'Y_M',Y_M_val,'Y_H',Y_H_val,'M_D',M_D_val,'H_D',H_D_val,'M_V',M_V_val,'H_V',H_V_val);
    case 'mcra'
        parameters = struct('n',2,'len',len_val,'P',ns_ps,'Pmin',ns_ps,'Ptmp',ns_ps,'pk',zeros(len_val,1),'noise_ps',ns_ps,...
            'ad',0.95,'as',0.8,'L',round(1000*2/20),'delta',5,'ap',0.2);
    case 'imcra'
        alpha_d_val=0.85;
        alpha_s_val=0.9;
        U_val=8;V_val=15;
        Bmin_val=1.66;gamma0_val=4.6;gamma1_val=3;
        psi0_val=1.67;alpha_val=0.92;beta_val=1.47;
        j_val=0;
        b_val=hanning(3);
        B_val=sum(b_val);
        b_val=b_val/B_val;
        Sf_val=zeros(len_val,1);Sf_tild_val=zeros(len_val,1);
        Sf_val(1) = ns_ps(1);
        for f=2:len_val-1
            Sf_val(f)=sum(b_val.*[ns_ps(f-1);ns_ps(f);ns_ps(f+1)]);
        end
        Sf_val(len_val)=ns_ps(len_val);
        Sf_tild_val = zeros(len_val,1);
        parameters = struct('n',2,'len',len_val,'noise_ps',ns_ps,'noise_tild',ns_ps,'gamma',ones(len_val,1),'Sf',Sf_val,...
            'Smin',Sf_val,'S',Sf_val,'S_tild',Sf_val,'GH1',ones(len_val,1),'Smin_tild',Sf_val,'Smin_sw',Sf_val,'Smin_sw_tild',Sf_val,...
            'stored_min',max(ns_ps)*ones(len_val,U_val),'stored_min_tild',max(ns_ps)*ones(len_val,U_val),'u1',1,'u2',1,'j',2,...
            'alpha_d',0.85,'alpha_s',0.9,'U',8,'V',15,'Bmin',1.66,'gamma0',4.6,'gamma1',3,'psi0',1.67,'alpha',0.92,'beta',1.47,...
            'b',b_val,'Sf_tild',Sf_tild_val);
    case 'doblinger'
        parameters = struct('n',2,'len',len_val,'alpha',0.7,'beta',0.96,'gamma',0.998,'noise_ps',ns_ps,'pxk_old',ns_ps,...
            'pxk',ns_ps,'pnk_old',ns_ps,'pnk',ns_ps);
    case 'hirsch'
        parameters = struct('n',2,'len',len_val,'as',0.85,'beta',1.5,'omin',1.5,'noise_ps',ns_ps,'P',ns_ps);
    case 'mcra2'
        freq_res=Srate/len_val;
        k_1khz=floor(1000/freq_res);
        k_3khz=floor(3000/freq_res);
        %delta_val=[2*ones(k_1khz,1);2*ones(k_3khz-k_1khz,1);5*ones(len_val/2-k_3khz,1);...
        %    5*ones(len_val/2-k_3khz,1);2*ones(k_3khz-k_1khz,1);2*ones(k_1khz,1)];
         delta_val=[2*ones(k_1khz,1);2*ones(k_3khz-k_1khz,1);5*ones(len_val/2-k_3khz,1)];
			delta_val=[delta_val;5;flipud(delta_val(2:end))];

        parameters = struct('n',2,'len',len_val,'ad',0.95,'as',0.8,'ap',0.2,'beta',0.8,'beta1',0.98,'gamma',0.998,'alpha',0.7,...
            'delta',delta_val,'pk',zeros(len_val,1),'noise_ps',ns_ps,'pxk_old',ns_ps,'pxk',ns_ps,'pnk_old',ns_ps,'pnk',ns_ps);
        
      case 'conn_freq'
        D = 7; 
        b = triang(2*D+1)/sum(triang(2*D+1));
        b = b';
        beta_min = 0.7; % for R's recursion
        U = 5;
        V = 8;
        gamma1 = 6; 
        gamma2 = 0.5; 
        K_tild = 2*sum(b.^2)^2/sum(b.^4);
        alpha_max_val=0.96; 
        alpha_min_val=0.3;
        stored_min = max(ns_ps)*ones(len_val,U);
        
        alpha_c = 0.7;
        noise_ps = ns_ps;
        Rmin_old = 1;
        Pmin_sw = ns_ps;
        Pmin = ns_ps;
        P = ns_ps;
        Decision = zeros(size(P));
        u1 = 1;
        j = 0;
        parameters = struct('len',len_val,'D',D,'b',b,'U',U,'V',V,'gamma1',gamma1,'gamma2',gamma2,'K_tild',K_tild,'alpha_c',alpha_c,...
            'noise_ps',noise_ps,'Rmin_old',Rmin_old,'Pmin_sw',Pmin_sw,'Pmin',Pmin,'SmthdP',P,'u1',u1,'j',j,'alpha',0,'alpha_max',alpha_max_val,...
            'stored_min',stored_min,'beta_min',beta_min,'Decision',Decision);

     case 'mmse_psd'
        MIN_GAIN =eps;
        gamma=1;
        nu=0.6;
        [g_dft,g_mag,g_mag2]=Tabulate_gain_functions(gamma,nu); %% tabulate the gain function used later on

        %%%%%%%%%%%%%
        %The tabulated gain functions compute the estimator based on the papers published in
        %
        %
        %[1] J.S. Erkelens, R.C. Hendriks, R. Heusdens, and J. Jensen,
        %"Minimum mean-square error estimation of discrete Fourier coefficients with generalized gamma priors",
        %IEEE Trans. on Audio, Speech and Language Proc., vol. 15, no. 6, pp. 1741 - 1752, August 2007.
        %
        %[2] J.S. Erkelens, R.C. Hendriks and R. Heusdens
        %"On the Estimation of Complex Speech DFT Coefficients without Assuming Independent Real and Imaginary Parts",
        %IEEE Signal Processing Letters, 2008.
        %
        %[3] R.C. Hendriks, J.S. Erkelens and R. Heusdens
        %"Comparison of complex-DFT estimators with and without the independence assumption of real and imaginary parts",
        %ICASSP, 2008.

        ALPHA= 0.98; %% this is the smoothing factor used in the decision directed approach
        SNR_LOW_LIM=eps;
        Rprior=-40:1:100;% dB
        [tabel_inc_gamma ]=tab_inc_gamma(Rprior,2);         
        ALPHA= 0.98; %% this is the smoothing factor used in the decision directed approach
        SNR_LOW_LIM=eps;
        noise_ps = ns_ps;
        
        parameters = struct('n',1,'g_mag',g_mag,'len',len_val,'tabel_inc_gamma',...
            tabel_inc_gamma,'ALPHA',ALPHA,'SNR_LOW_LIM',SNR_LOW_LIM,...
            'noise_psd',noise_psd,'MIN_GAIN',MIN_GAIN,'nFrame',nFrame,...
            'min_mat',min_mat,'Srate',Srate,'noise_ps',noise_ps);
    
    case 'unbiased_mmse'
        PH1mean  = 0.5;
        alphaPH1mean = 0.9;
        alphaPSD = 0.8;
        
        noise_ps = ns_ps;
        
        %constants for a posteriori SPP
        q          = 0.5; % a priori probability of speech presence:
        priorFact  = q./(1-q);
        xiOptDb    = 15; % optimal fixed a priori SNR for SPP estimation
        xiOpt      = 10.^(xiOptDb./10);
        logGLRFact = log(1./(1+xiOpt));
        GLRexp     = xiOpt./(1+xiOpt);

        parameters = struct('n',1,'PH1mean',PH1mean,'alphaPH1mean',alphaPH1mean,...
            'alphaPSD',alphaPSD,'q',q,'priorFact',priorFact,'xiOptDb',...
            xiOptDb,'xiOpt',xiOpt,'logGLRFact',logGLRFact,'GLRexp',GLRexp,...
            'noise_psd',noise_psd,'noise_ps',noise_ps);
    
    case 'npsd_rs'
        alpha_n = 0.8;                
        alpha_x = 0.85;           % It is equivalent to a smoothing window with the length of 0.2s  
    
        thetaMean = [0.6002  1.4655  0.2575  0.5043]';
        Sigma = diag([0.0640  0.5406  0.0120  0.0192]);
        
        SigmaInv = inv(Sigma);
        
        noise_ps = ns_ps;
        
        delta1 = 4;  %                  
        delta2 = 8;  % Parameters to compute speech presence probability                              

        Pkl = zeros(len_val,Nframes);                 % Smoothed Periodograms
        pkl = zeros(len_val,Nframes);                 % Speech presence probability
        dkl = zeros(len_val,Nframes);                 % Normalized distance between regional statistics of noisy signal and Expectation vector
        dklSmo = zeros(len_val,Nframes);              % Smoothed normalized distance        
        periodograms = zeros(len_val,Nframes);        % Periodograms 
        theta_nv = thetaMean(1);      % Normalized Variance         
        theta_ndv = thetaMean(2);     % Normalized Differential Variance
        theta_nav = thetaMean(3);     % Normalized Average Variance
        theta_mcr = thetaMean(4);     % Median Crossing           
        
        
        parameters = struct('n',2,'alpha_n',alpha_n,'alpha_x',alpha_x,...
            'thetaMean',thetaMean,'SigmaInv',SigmaInv,...
            'delta1',delta1,'delta2',delta2,'noise_psd',noise_psd,...
            'noise_ps',noise_ps,'pkl',pkl,'Pkl',Pkl,'theta_nv',...
            theta_nv,'theta_ndv',theta_ndv,'theta_nav',theta_nav,...
            'theta_mcr',theta_mcr,'dkl',dkl,'dklSmo',dklSmo,...
            'periodograms',periodograms);
        
    otherwise
            error('Method not implemented. Check spelling.');
end