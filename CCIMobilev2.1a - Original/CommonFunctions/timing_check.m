% Error Checking Routine
% Author: Hussnain Ali
% Date:   12/07/2010
%         University of Texas at Dallas (c) Copyright 2010
%
% Parameter Checking routines for rate and pulse width adjustments
% Used to calculate correct number of pulse per frame per channel

function [mod_map] = timing_check(org_map)

mod_map=org_map;

if (isfield(org_map,'Left')==1)
    % check left parameters
    num_selected=org_map.Left.Nmaxima;
    pw=org_map.Left.PulseWidth;
    rate=org_map.Left.StimulationRate;
    ipg = org_map.Left.IPG;
    [rate_outL, pw_outL, ppfpchL] = check_timing_parameters(num_selected, rate, pw, ipg);
    mod_map.Left.StimulationRate=rate_outL;
    mod_map.Left.PulseWidth=pw_outL;
    mod_map.Left.pulses_per_frame_per_channel=ppfpchL;
    mod_map.Left.pulses_per_frame=ppfpchL*num_selected;
end

if (isfield(org_map,'Right')==1)
    % check right parameters
    num_selected=org_map.Right.Nmaxima;
    pw=org_map.Right.PulseWidth;
    rate=org_map.Right.StimulationRate;
    ipg = org_map.Right.IPG;
    [rate_outR, pw_outR, ppfpchR] = check_timing_parameters(num_selected, rate, pw, ipg);
    mod_map.Right.StimulationRate=rate_outR;
    mod_map.Right.PulseWidth=pw_outR;
    mod_map.Right.pulses_per_frame_per_channel=ppfpchR;
    mod_map.Right.pulses_per_frame=ppfpchR*num_selected;
end


%% Check timing
    function [rate_set, pw_set, pulses_per_frame_per_channel] = check_timing_parameters(num_selected, rate, pw, IPG)
        % Check Pulse Width
        if pw>400
            pw=400; pw_set=400;
        end
        if pw<25
            pw=25; pw_set=25;
        end

        SG=0; AG=1;
        Total_Stimulation_Rate=14400; thr=Total_Stimulation_Rate; % This is the maximum stimulation rate supported by CIC4 in STD mode
        
        if (num_selected*rate<=thr)&&(rate<=thr)
            protocol='STD'; %%% Standard Rate Protocol
            max_pw_STD=floor(1e6/(rate*num_selected) - (IPG+SG+AG-0.5));
            if pw>max_pw_STD
                pw_set=max_pw_STD;
            else
                pw_set=pw; % Keep the same pw
            end
        else
            errordlg('High Rate Protocol is currently not supported');
            protocol='HRT'; % High Rate Protocol (HR)
            while (num_selected*rate>thr)
                rate=rate-1;
            end
            rate_set=floor(rate);
            % Inform user abt the rate changed
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Pulse Width Centric
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        T_pw =floor(((pw*2.0+IPG+6.0+1.0)*num_selected)+0.5);
        T_rate = floor(1000000/rate+0.5);
        
        if (T_pw>T_rate)
            ratetest=rate;
            while (T_pw>T_rate)
                ratetest=ratetest-1;
                T_rate = 1000000/rate+0.5;
            end
            rate_set =floor(ratetest);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Pulses per frame per channel
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        if exist('rate_set','var')==1
            rate_set = floor(rate_set);
        else
            rate_set=floor(rate);
        end
        if exist ('pw_set', 'var')==1
            pw_set = floor(pw_set);
        else
            pw_set=floor(pw);
        end
        
        pulses_per_frame_per_channel=round((8.0*rate_set)/1000); %floor(0.5+floor((8.0*rate_set)/1000));
        pulses_per_frame= num_selected*pulses_per_frame_per_channel;
        rate_set=125*pulses_per_frame_per_channel;
        
        if rate_set~=rate && pw_set~=pw
            %warndlg('Rate and Pulse Width has been adjusted','Rate and Pulse-width adjustment')
            disp(['Rate has been adjusted to: ', num2str(rate_set), ' pps']);
            disp(['Pulse Width has been adjusted to: ', num2str(pw_set), ' us']);
        elseif pw_set~=pw
            %warndlg('Pulse Width has been adjusted','Pulse-width adjustment')
            disp(['Pulse Width has been adjusted to: ', num2str(pw_set), ' us']);
        elseif rate_set~=rate
            %warndlg('Rate has been adjusted','Rate adjustment')
            disp(['Rate has been adjusted to: ', num2str(rate_set), ' pps']);
        end
        
    end


end