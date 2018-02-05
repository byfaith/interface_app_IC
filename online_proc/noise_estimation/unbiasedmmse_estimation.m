function [parameters] = unbiasedmmse_estimation(ns_ps,parameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% propose SPP algorithm to estimate the spectral noise power
%%%% papers: "Unbiased MMSE-Based Noise Power Estimation with Low Complexity and Low Tracking Delay", IEEE TASL, 2012 
%%%% "Noise Power Estimation Based on the Probability of Speech Presence", Timo Gerkmann and Richard Hendriks, WASPAA 2011
%%%% Input :        noisy:  noisy signal
%%%%                   fs:  sampling frequency
%%%%                   
%%%% Output:  noisePowMat:  matrix with estimated noise power for each frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Copyright (c) 2011, Timo Gerkmann
%%%%%%%%%%%%%%%%%%%%%% Author: Timo Gerkmann and Richard Hendriks
%%%%%%%%%%%%%%%%%%%%%% Universitaet Oldenburg
%%%%%%%%%%%%%%%%%%%%%% KTH Royal Institute of Technology
%%%%%%%%%%%%%%%%%%%%%% Delft university of Technology
%%%%%%%%%%%%%%%%%%%%%% Contact: timo.gerkmann@uni-oldenburg.de
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the Universitaet Oldenburg, Delft university, KTH 
%	Royal Institute of Technology nor the names of its contributors may be 
% 	used to endorse or promote products derived from this software without 
% 	specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%
% Version v1.0 (October 2011)

%         parameters = struct('PH1mean',PH1mean,'alphaPH1mean',alphaPH1mean,...
%             'alphaPSD',alphaPSD,'q',q,'priorFact',priorFact,'xiOptDb',...
%             xiOptDb,'xiOpt',xiOpt,'logGLRFact',logGLRFact,'GLRexp',GLRexp,...
%             'noise_psd',noise_psd,'noise_ps',noise_psd);

n = parameters.n;
PH1mean = parameters.PH1mean;
alphaPH1mean = parameters.alphaPH1mean;
alphaPSD = parameters.alphaPSD;
q = parameters.q;
priorFact = parameters.priorFact;
xiOptDb = parameters.xiOptDb;
xiOptDb=parameters.xiOptDb;
logGLRFact = parameters.logGLRFact;
GLRexp = parameters.GLRexp;
noisyPer = ns_ps;

if n==1
    noisePow = parameters.noise_psd;
else
    noisePow = parameters.noise_ps;
end

snrPost1 =  ns_ps./(noisePow);% a posteriori SNR based on old noise power estimate

%% noise power estimation
GLR     = priorFact .* exp(min(logGLRFact + GLRexp.*snrPost1,200));
PH1     = GLR./(1+GLR); % a posteriori speech presence probability

PH1mean  = alphaPH1mean * PH1mean + (1-alphaPH1mean) * PH1;
stuckInd = PH1mean > 0.99;
PH1(stuckInd) = min(PH1(stuckInd),0.99);
estimate =  PH1 .* noisePow + (1-PH1) .* noisyPer ;
noisePow = alphaPSD *noisePow+(1-alphaPSD)*estimate;

%%
% parameters.noisePow = noisePow;
parameters.noise_ps = noisePow;
parameters.PH1mean = PH1mean;
parameters.alphaPH1mean = alphaPH1mean;
parameters.alphaPSD = alphaPSD;
parameters.q = q;
parameters.priorFact = priorFact;
parameters.xiOptDb = xiOptDb;
parameters.xiOptDb = xiOptDb;
parameters.logGLRFact = logGLRFact;
parameters.GLRexp = GLRexp;
