function [snrUn_values, wrcAvrgValues] = wrcAvrg(snr_orderUn, wrcUn_order)
% [snrUn_values, wrcAvrgValues] = wrcAvrg(snr_orderUn, wrcUn_order)

% Organize SNR data 
for k=1:length(snr_orderUn)
    if k==1
        a(k) = snr_orderUn(k);
    elseif k~=1 && (snr_orderUn(k)~=snr_orderUn(k-1))
        a(k) = snr_orderUn(k);
    end
end

% discart null values
snrUn_values = a(a~=0);
snrUn_values = snrUn_values';

% Get WRC average values.
q = 1;
for p=1:length(snrUn_values)
    s = 1;
    bb = 0;
    while snr_orderUn(q,1) == snrUn_values(p,1)
        b(q,1) = wrcUn_order(q,1);
        bb = bb + b(q,1);        
        q = q+1;
        s = s+1;
        if q > length(snr_orderUn)
            break
        end        
    end
    s = s-1;
    c(p,1) = bb/s;
end
wrcAvrgValues = c;
