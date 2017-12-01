function Stream(stimuli)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funtion Stream(signal) reads the stimuli and its parameters from the input
% structure signal and streams them to the CCIMobile platform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Author: Hussnain Ali
%               Date: 06/21/16
% University of Texas at Dallas (c) Copyright 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=stimuli.map;
s = initializeBoard(p);
outputBuffer = create_output_buffer(p);

if (isfield(p,'Left') ==1)
    npulsesL = p.Left.pulses_per_frame;
    total_pulses_L = numel(stimuli.left.current_levels);
    nframesL = floor(total_pulses_L/npulsesL);
else
    npulsesL = 0; total_pulses_L = 0; nframesL = 0;
end
if (isfield(p,'Right') ==1)
    npulsesR = p.Right.pulses_per_frame;
    total_pulses_R = numel(stimuli.right.current_levels);
    nframesR = floor(total_pulses_R/npulsesR);
else
    npulsesR = 0; total_pulses_R = 0;  nframesR=0;
end

nframes = max(nframesL,nframesR); % while loop will run for nframes
%% Stream
indL = 0; indR = 0;
frame_no=1;

while frame_no<nframes-1 % use while else timing won't be right
    if Wait(s)>= 512
        AD_data_bytes = Read(s, 512);
        
        if (isfield(p,'Left') ==1)&&(p.General.LeftOn == 1)
            if frame_no<=nframesL
                a=7;
                for (i=1:npulsesL)
                    outputBuffer(a) = uint8(stimuli.left.electrodes(i+indL)); a=a+1; %left electrodes
                end
                a= 133;
                for (i=1:npulsesL)
                    outputBuffer(a) = uint8(stimuli.left.current_levels(i+indL)); a=a+1; %left amplitudes
                end
            else
                %a= 133;
                outputBuffer(133:248) = uint8(0); %zero out left amplitudes, if not active
            end
        else
            %a= 133;
            outputBuffer(133:248) = uint8(0); %zero out left amplitudes, if not active
        end
        
        if (isfield(p,'Right') ==1)&&(p.General.RightOn == 1)
            if frame_no<=nframesR
                a=265;
                for (i=1:npulsesR)
                    outputBuffer(a) =uint8(stimuli.right.electrodes(i+indR)); a=a+1; %right electrodes
                end
                a=391;
                for (i=1:npulsesR)
                    outputBuffer(a) = uint8(stimuli.right.current_levels(i+indR)); a=a+1; %right amplitudes
                end
            else
                %a = 391;
                outputBuffer(391:506) = uint8(0); %zero out right amplitudes
            end
        else
            %a = 391;
            outputBuffer(391:506) = uint8(0); %zero out right amplitudes
        end
        
        Write(s, outputBuffer,516); % Write output to the board
        
        indL = indL + npulsesL;
        indR = indR + npulsesR;
        frame_no = frame_no+1;
    end
    
end
delete(s); clear s;
