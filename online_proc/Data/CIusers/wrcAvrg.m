function [snrUn_values, wrcAvrgValues, dataBox] = wrcAvrg(snr_orderUn, wrcUn_order)
% [snrUn_values, wrcAvrgValues, dataBox] = wrcAvrg(snr_orderUn, wrcUn_order)

% Organize SNR data 
for k=1:length(snr_orderUn)
    if k==1
        a(k) = snr_orderUn(k);
    elseif k~=1 && (snr_orderUn(k)~=snr_orderUn(k-1))
        a(k) = snr_orderUn(k);
    end
end

% discart null values (FIRSTLY DETECT ZERO VALUES, THEN DISCART BELOW AND ABOVE VALUES)
pos = 0;
for l=1:length(snr_orderUn)
    if snr_orderUn(l) == 0 && pos == 0
        pos = l;
    end
end
if pos ~= 0
    snr_values1 = a(1,1:pos);
    snr_values2 = a(1,pos+2:end);
    snr_values1 = snr_values1(snr_values1~=0);
    snr_values2 = snr_values2(snr_values2~=0);
    snrUn_values = [snr_values1 0 snr_values2];
else
  snrUn_values = a(a~=0);  
end
% snrUn_values = a(a~=0);
% snrUn_values = a;
snrUn_values = snrUn_values';

% Get WRC average values.
q = 1;
for p=1:length(snrUn_values)
    s = 1;
    bb = 0;
    while snr_orderUn(q,1) == snrUn_values(p,1)
        b(q,1) = wrcUn_order(q,1);
        bb = bb + b(q,1);
        dataBox(q,p) = b(q,1);
        q = q+1;
        s = s+1;
        if q > length(snr_orderUn)
            break
        end   
    end
    s = s-1;
    if s==0
        s=1;
    end
    c(p,1) = bb/s;
end
wrcAvrgValues = c;