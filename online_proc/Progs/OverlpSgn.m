function [ModSignal, PhaseSignal, SigBin, output_signal] = OverlpSgn(Input)
% Return a matrix contain modulo and phase FFT values of M bins with
% SignalSize/[round(WindowSize*(1-SignalSize/100))]
% [ModSignal,PhaseSignal] = OverlpSgn(Input)
% ModSignal: Signal Module
% PhaseSignal: Signal Phase 
% SigBin: Bin associated (module and phase)
% output_signal: Synthesis signal

%--------------------------------------------------------------------------
% fft parameters
%--------------------------------------------------------------------------
M  =   128;         % length of the fft (48kHz and M=256 W=32 S=50)
W  =   64;         % length of the analysis window (128) [1]
S  =    50;         % overlap (percentual) (50%) [1]

%--------------------------------------------------------------------------
% weighted overlap-add memory allocation
%--------------------------------------------------------------------------
input_signal = Input;
tamsign = length(Input);
buff_in_tmp_in = zeros(M,1);    % input buffer in the time domain
buff_in_frq_in = zeros(M,1);    % input in the frequency domain
buff_out_tmp_in  = zeros(M,1);        % output buffer in the time domain (input signal)
buff_out_frq_in  = zeros(M,1);        % output buffer in the frequency domain  (input signal)
output_signal    = zeros(tamsign,1);  % output signal
buff_vad         = zeros(M,1);            % vad buffer
wm               = exp(1i*2*pi/M);        % complex exponential
bloco            = round(W*(1-S/100));    % innovation block
janela           = [zeros((M-W)/2,1);flipdim(sqrt(hann(W)),2);zeros((M-W)/2,1)];
count_block      = 0;

SignOverl = zeros(M,round(tamsign/bloco));

ModSignal = zeros(M,round(tamsign/bloco));
PhaseSignal = zeros(M,round(tamsign/bloco));


for sample = 1 : tamsign
    
%     buff_vad = [ speech_vad(sample) ; buff_vad(1:M-1) ];
    
    buff_in_tmp_in = [ buff_in_tmp_in(2:M,:) ; input_signal(sample,:) ];
    
    buff_out_tmp_in(:,1) = [ buff_out_tmp_in(2:M,1) ; 0 ];
%     buff_out_tmp_in(:,2) = [ buff_out_tmp_in(2:M,2) ; 0 ];
    
    if( ~mod(sample,bloco) )
        
        % Progress
        if( ~mod(sample,1000) )
                disp(['Progress: ', num2str(floor(100*sample/tamsign)),'%']);
        end
            
        % Phase modification ----------------------------------------------
        count_block = count_block + 1;
        fact  = (((-1).^(0:M-1)).*(wm.^(-count_block*bloco*(0:M-1))))';
        
        % Analysis --------------------------------------------------------
        for channel = 1 : 1
            buff_in_frq_in(:,channel) = fact.*fft(janela.*buff_in_tmp_in(:,channel));
        end

        ModSignal(:,count_block) = abs(fact.*fft(janela.*buff_in_tmp_in(:,1))).^2;
        PhaseSignal(:,count_block) = angle(fact.*fft(janela.*buff_in_tmp_in(:,1)));
        SigBin(:,count_block) = fact.*fft(janela.*buff_in_tmp_in(:,1));
        
        
        
        
        
        
        % Output = input
        buff_out_frq_in = buff_in_frq_in;
                                        
        % Synthesis ---------------------------------------------------
        buff_out_tmp_in(:) = buff_out_tmp_in(:) + janela .* ifft(conj(fact).*buff_out_frq_in(:));
     

        % Overlap-add -------------------------------------------------
        output_signal(sample-bloco+1:sample) = real(buff_out_tmp_in(1:bloco,1));
    end
end


end