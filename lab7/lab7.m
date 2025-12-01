clear all 
clc

% a)

wejscie945 = load('wejscie945');
wyjscie945 = load('wyjscie945');


U945 = fft(wejscie945,1024);
Y945 = fft(wyjscie945,1024);

G945 = Y945./U945;

figure;
plot(real(G945(1:513)),imag(G945(1:513)),'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 945')

wejscie1130 = load('wejscie1130');
wyjscie1130 = load('wyjscie1130');


U1130 = fft(wejscie1130,1024);
Y1130 = fft(wyjscie1130,1024);

G1130 = Y1130./U1130;

figure;
plot(real(G1130(1:513)),imag(G1130(1:513)),'o')
xlabel('Re(G)')
ylabel('Im(G)')
title('Charakterystyka Nyquista dla danych 1130')

% b)







