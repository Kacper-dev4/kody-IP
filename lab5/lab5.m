clear all 
clc
N = 8;
krone1 = eye(1,N);
krone2 = zeros(1,N);
krone2(4)=1;

Nsin = 1024;
t = 0:0.01:10.23;
A = 1;

sin1 = A*sin(t*50*(2*pi/Nsin));
sin2 = A*sin(t*50.3*(2*pi/Nsin));

widmoKrone1 = fft(krone1);
widmoKrone2 = fft(krone2);

widmoSin1 = fft(sin1);
widmoSin2 = fft(sin2);

N1 = length(krone1);
f1 = (0:N1-1)*(1/(t(2)-t(1))/N1);

N2 = length(sin1);
f2 = (0:N2-1)*(1/(t(2)-t(1))/N2);

figure 
plot(f1,abs(widmoKrone1),'o')

figure
plot(f1,abs(widmoKrone2),'o')

figure
plot(f2,abs(widmoSin1),'o')

figure
plot(f2,abs(widmoSin2),'o')