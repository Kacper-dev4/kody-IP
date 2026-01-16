clear all
clc

[sig, Fs] = audioread("U.m4a"); 

%[GWM, czest] = odcinkoweUsre(sig,100,Fs);
N = length(sig);
y = fft(sig);
GWM = abs(y);
GWM = GWM(1:120833);
f = Fs*(0:(N/2))/N;
figure;
plot(f, 10*log10(GWM));
grid on;
title('GWM');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB/Hz]');