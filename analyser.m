[y,Fs]=audioread('Recording 4 – 98.3.mp4');
[x,Fs2]=audioread('03 - Wonderwall.mp4');
Fy = fftshift(abs(fft(y)));
fy = linspace(-Fs/2, Fs/2, numel(y));
fy(end) = [];    
Fx = fftshift(abs(fft(x)));
fx=linspace(-Fs2, Fs, numel(x));
fx(end)=[];

% For plotting purposes 
    plot(f, F);
    subplot(1,2,1);   
    plot(fft(y));
    subplot(1,2,2);
    plot(fft(x));
    figure;
    subplot(1,2,1);
    plot(fy);
    subplot(1,2,1);
    plot(fx);

% frequency range    
    disp(range(Fy));    
    disp(range(Fx));