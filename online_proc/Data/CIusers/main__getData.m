% Get SRT50 
clear all
clc
%% MMSE
% addpath('Data\CIusers\Marina')
% addpath('Marina')
% load('Marina_MMSE.mat')

addpath('Data\CIusers\Rosana')
addpath('Rosana')
load('Ro_MMSE.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
% Get WRC x SNR
wrcMMSE = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

figure;plot(snr,'-.')
hold on
% title('MMSE')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])
%% Wiener
% addpath('Data\CIusers\Marina')
% load('Marina_Wiener.mat')
addpath('Data\CIusers\Rosana')
load('Ro_Wiener.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
% Get WRC x SNR
wrcWiener = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

hold on;plot(snr,'-')
hold on
% title('Wiener')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])

%% Binary Mask
% addpath('Data\CIusers\Marina')
% load('Marina_Binary.mat')
addpath('Data\CIusers\Rosana')
load('Ro_BMsk.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
% Get WRC x SNR
wrcBMsk = resultados.numAcertos(index)./resultados.numTotalPalavras(index);

plot(snr,'--')
hold on
% title('Binary Mask')
% xlabel('Trial number')
% ylabel('SNR [dB]')
axis([0 35 -10 25 ])
%% Unproc
% addpath('Data\CIusers\Marina')
% load('Marina_Un.mat')
addpath('Data\CIusers\Rosana')
load('Ro_Un.mat')

index = find(resultados.numTotalPalavras);
snr = resultados.snr_vecValues(index);
% Get WRC x SNR
wrcUn = resultados.numAcertos(index)./resultados.numTotalPalavras(index);
[wrcUn_order, index_wrcUn] = sort(wrcUn);
snr_orderUn = sort(snr(index_wrcUn));
figure;scatter(snr_orderUn, wrcUn_order)
% Now, approximate to logit function

plot(snr)
hold on
xlabel('Trial number')
ylabel('SNR [dB]')
axis([0 35 -10 25 ])
h = legend('MMSE', 'Wiener', 'Máscara Binária', 'Não-processado');
set(h);


%% Plot WRC x SNR, per each strategy. Then approximates by logit curve

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

% Send SNR and WRC average values
[ffit, curve] = FitPsycheCurveWH(snrUn_values, wrcAvrgValues, 0);

% Plot real values and logit approximation
figure;scatter(snr_orderUn, wrcUn_order)
figure;plot(curve(:,1),100.*curve(:,2))


