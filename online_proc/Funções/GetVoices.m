function [voice,FS,nbitsSig] = GetVoices(path,NS)
% voice = GetVoices(path,NS)
% path:  caminho arquivos de voz
% NS:    numeros de sinais
% voice: arquivos de voz

voice = [];
fs = [];

for i=1:1:NS
    % define source file
    
    if i < 10
        path_pass = strcat(path,'0');
        nameFile = strcat(path_pass,num2str(i),'.wav');
    else
        nameFile = strcat(path,num2str(i),'.wav');
    end
    %[R,FS,nbitsSig] = wavread(nameFile);
    [R,FS] = audioread(nameFile);
    info = audioinfo(nameFile);
    nbitsSig = info.BitsPerSample;
    
    % Storage voice signal throught matrix vector
    for j=1:1:length(R)
        if j==1
            % First line indicates the length of the signal
            voice(j,i) = length(R);
        else
            voice(j,i) = R(j);
            fs(1,i) = FS;
        end
    end
    disp(['Import Audio:: ' num2str(i)]);
end

end