%% Zad1
Fs = 10;         
T = 0.1;         
N = 8;           
N2 = 1024;       
f_bin = Fs / N2; 
n1 = 0:N-1;      
x1 = zeros(1, N);
x1(1) = 1;       
x2 = zeros(1, N);
x2(4) = 1;     
n3 = 0:N2-1;     
f3 = 50 * f_bin; 
x3 = sin(2*pi*f3*n3/Fs); 
f4 = 50.3 * f_bin;
x4 = sin(2*pi*f4*n3/Fs); 
% Obliczanie FFT
X1 = fft(x1, N);    
X2 = fft(x2, N);    
X3 = fft(x3, N2);   
X4 = fft(x4, N2);   
f = (0:N-1) * Fs / N;
f2 = (0:N2-1) * Fs / N2;
f2 = f2;
% Rysowanie sygnałów w dziedzinie czasu
figure;
subplot(2,2,1);
stem(n1, x1, 'filled');
title('Delta Kroneckera umiejscowiona w chwili 0 (N=8)');
xlabel('Czas (próbki)');
ylabel('Amplituda');
subplot(2,2,2);
stem(n1, x2, 'filled');
title('Delta Kroneckera umiejscowiona w chwili 3 (N=8)');
xlabel('Czas (próbki)');
ylabel('Amplituda');
subplot(2,2,3);
plot(n3, x3);
title('Sinusoida (f = 50 razy bin)');
xlabel('Czas (próbki)');
ylabel('Amplituda');
subplot(2,2,4);
plot(n3, x4);
title('Sinusoida (f = 50.3 razy bin)');
xlabel('Czas (próbki)');
ylabel('Amplituda');
% Rysowanie widm w dziedzinie częstotliwości
figure;
subplot(2,2,1);
plot(f, abs(X1));
title('Widmo dla Delta Kroneckera umiejscowionej w chwili 0');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');
subplot(2,2,2);
plot(f, abs(X2));
title('Widmo dla Delta Kroneckera umiejscowionej w chwili 3');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');
subplot(2,2,3);
plot(f2(1:512), abs(X3(1:512)));
title('Widmo dla sinusoidy (f = 50 razy bin)');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');
subplot(2,2,4);
plot(f2(1:512), abs(X4(1:512)));
title('Widmo dla sinusoidy (f = 50.3 razy bin)');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');

%% Zad2

szum = x3;
Fs = 10;
[gwm,fx3] = odcinkoweUsre(szum,10,Fs);

%% Zad3


N  = 100000;     
Fs = 100;      
t  = (0:N-1)'/Fs;

rng(0);  
szum = randn(N,1); 

f1 = 1;   A1 = 2;   phi1 = 0;
f2 = 2;  A2 = 1.5; phi2 = pi/3;
f3 = 5;  A3 = 0.8; phi3 = pi/2;

sinusoidy = A1*sin(2*pi*f1*t + phi1) + ...
            A2*sin(2*pi*f2*t + phi2) + ...
            A3*sin(2*pi*f3*t + phi3);
a = [1, -0.9, 0.16];  
e = randn(N,1);

AR2 = filter(1, a, e);  

sygnal_mieszany = sinusoidy + AR2;

figure('Position',[100 100 900 600]);
subplot(4,1,1); plot(t(1:2000), szum(1:2000));      title('1. Biały szum N(0,1)');      grid on;
subplot(4,1,2); plot(t(1:2000), sinusoidy(1:2000)); title('2. Suma 3 sinusoid');        grid on;
subplot(4,1,3); plot(t(1:2000), AR2(1:2000));       title('3. Ciąg AR(2)');             grid on;
subplot(4,1,4); plot(t(1:2000), sygnal_mieszany(1:2000)); 
title('4. Suma: sinusoidy + AR(2)'); grid on; xlabel('Czas [s]');

%% Zad4
Ts = 0.01;
Fs = 1/Ts;
podzial = 100;

% biały szum
[GWMszum, fszum] = odcinkoweUsre(szum,podzial,Fs);
DTF = fft(szum);
GWMszumZwyczajnie = abs(DTF);
GWMszumZwyczajnie = GWMszumZwyczajnie(1:floor(N/2)+1);
GWMszumZwyczajnie = (1/(N))*(GWMszumZwyczajnie).^2;
f = (0:length(GWMszumZwyczajnie)-1) * Fs / N;
figure
hold on
plot(f,10*log10(GWMszumZwyczajnie));
plot(fszum,10*log10(GWMszum))
xlabel('Częstotliwość [Hz]');
ylabel('GWM(dB)');
legend('Periodogram','Periodogram metoda uśrednianie odcinkowe')

% sinusoidy

[GWMsin, fsin] = odcinkoweUsre(sinusoidy,podzial,Fs);
DTF = fft(sinusoidy);
GWMsinZwyczajnie = abs(DTF);
GWMsinZwyczajnie = GWMsinZwyczajnie(1:floor(N/2)+1);
GWMsinZwyczajnie = (1/(N))*(GWMsinZwyczajnie).^2;
f = (0:length(GWMsinZwyczajnie)-1) * Fs / N;
figure
hold on
plot(f,10*log10(GWMsinZwyczajnie));
plot(fsin,10*log10(GWMsin))
xlabel('Częstotliwość [Hz]');
ylabel('GWM(dB)');
legend('Periodogram','Periodogram metoda uśrednianie odcinkowe')

% AR

[GWMar, far] = odcinkoweUsre(AR2,podzial,Fs);
DTF = fft(AR2);
GWMarZwyczajnie = abs(DTF);
GWMarZwyczajnie = GWMarZwyczajnie(1:floor(N/2)+1);
GWMarZwyczajnie = (1/(N))*(GWMarZwyczajnie).^2;
f = (0:length(GWMarZwyczajnie)-1) * Fs / N;
figure
hold on
plot(f,10*log10(GWMarZwyczajnie));
plot(far,10*log10(GWMar))
xlabel('Częstotliwość [Hz]');
ylabel('GWM(dB)');
legend('Periodogram','Periodogram metoda uśrednianie odcinkowe')

% sygnal mieszany suma sinusoid i AR

[GWMmieszany, fmieszany] = odcinkoweUsre(sygnal_mieszany,podzial,Fs);
DTF = fft(sygnal_mieszany);
GWMmieszanyZwyczajnie = abs(DTF);
GWMmieszanyZwyczajnie = GWMmieszanyZwyczajnie(1:floor(N/2)+1);
GWMmieszanyZwyczajnie = (1/(N))*(GWMmieszanyZwyczajnie).^2;
f = (0:length(GWMmieszanyZwyczajnie)-1) * Fs / N;
figure
hold on
plot(f,10*log10(GWMmieszanyZwyczajnie));
plot(fmieszany,10*log10(GWMmieszany))
xlabel('Częstotliwość [Hz]');
ylabel('GWM(dB)');
legend('Periodogram','Periodogram metoda uśrednianie odcinkowe')



%% Zad5

