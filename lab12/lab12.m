clear all
clc

[sig, Fs] = audioread("nagranie.wav"); 

%[GWM, czest] = odcinkoweUsre(sig,100,Fs);
N = length(sig);
y = fft(sig);
GWM = abs(y);

f = Fs*(0:(N/2))/N;
GWM = GWM(1:length(f));
figure;
plot(f, 10*log10(GWM));
grid on;
title('GWM');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB/Hz]');



[sig, Fs] = audioread("nagranie.wav");

[GWM, f] = odcinkoweUsre(sig, 100, Fs);

figure;
plot(f, 10*log10(GWM));
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('GWM [dB/Hz]');
title('Gęstość widmowa mocy – metoda Welcha');
xlim([0 Fs/2]);
