
%zadanie1 
clc 
close all 
A=2;
x1 = rand(1,100)*2-1; 
x2 = rand(1,1000)*2-1; 
sig100= A*(x1>=0) -A*(x1<0); 
sig1000= A*(x2>=0) -A*(x2<0); 
czest = rand(1, 6) * pi; % Częstotliwości z przedziału [0, pi] 
faza1 = 2* pi * rand( 6 , 100 ); % Fazowe przesunięcia z przedziału [0, 2pi] 
faza2 = 2* pi * rand( 6 , 1000 );
t1 = linspace(0,10,100);
t2=linspace(0,100,1000);
s11 = A* sin(0.1 * pi * t1 + faza1( 1 , : ) ) ;
s21 = A* sin(0.2 * pi * t1 + faza1( 2 , : ) ) ;
s31 = A* sin(0.3 * pi * t1 + faza1( 3 , : ) ) ;
s41 = A* sin(0.4 * pi * t1 + faza1( 4 , : ) ) ;
s51 = A* sin(0.5 * pi * t1 + faza1( 5 , : ) ) ;
s61 = A* sin(0.6 * pi * t1 + faza1( 6 , : ) ) ;
s12 = A* sin( 0.1 * pi * t2 + faza2 ( 1 , : ) ) ;
s22 = A* sin( 0.2 * pi * t2 + faza2 ( 2 , : ) ) ;
s32 = A* sin( 0.3 * pi * t2 + faza2 ( 3 , : ) ) ;
s42 = A* sin( 0.4 * pi * t2 + faza2 ( 4 , : ) ) ;
s52 = A* sin( 0.5 * pi * t2 + faza2 ( 5 , : ) ) ;
s62 = A* sin( 0.6 * pi * t2 + faza2 ( 6 , : ) ) ;
sigsin100 = s11 + s21 + s31 + s41 + s51 + s61; 
sigsin1000 = s12 + s22 + s32 + s42 + s52 + s62 ;
x100 = 0:length(sig100)-1; 
x1000 = 0:length(sig1000)-1; 
figure(1) 
plot(x100,sig100); 
title('Sygnał binarny - 100 próbek') 
figure(2) 
plot(x1000,sig1000); 
title('Sygnał binarny - 1000 próbek'); 
figure(3) 
plot(x100,sigsin100); 
title('Sygnał sinusoidalny - 100 próbek'); 
figure(4) 
plot(x1000,sigsin1000) 
title('Sygnał sinusoidalny - 1000 próbek'); 
save('pobudzenie'); 
%zadanie2 
clc 
close all
%load('pobudzenie.mat'); 
%load('pomiaryZnanyObiekt.mat') 
num = [0 0 0 0.6 0.15];
dem = [1 -0.7 -0.1 0.45];
M=600;
impuls = [1, zeros(1, M - 1)];
wzorzec=filter(num, dem, impuls);
yb100 = filter(num,dem,sig100);
yb1000 = filter(num,dem,sig1000);
ysin100 = filter(num,dem,sigsin100);
ysin1000 = filter(num,dem,sigsin1000);
figure(1) 
noiseb100 = yb100+randn(size(yb100)) * sqrt(0.1 * var(yb100)); 
plot(x100, noiseb100); 
title('Sygnał binarny - 100 próbek - pobudzony z szumem') 
figure(2) 
noiseb1000 = yb1000+randn(size(yb1000)) * sqrt(0.1 * var(yb1000)); 
plot(x1000,noiseb1000);
title('Sygnał binarny - 1000 próbek - pobudzony z szumem') 
figure(4)
noisesin1000 = ysin1000+randn(size(ysin1000)) * sqrt(0.1 * var(ysin1000)); 
plot(x1000, noisesin1000); 
title('Sygnał sinusoidalny - 1000 próbek - pobudzony z szumem')
figure(3) 
noisesin100 = ysin100+randn(size(ysin100)) * sqrt(0.1 * var(ysin100)); 
plot(x100,noisesin100); 
title('Sygnał sinusoidalny - 100 próbek - pobudzony z szumem')
% Liczba identyfikowanych elementów odpowiedzi impulsowej
M = 20 ;
UB_100 = toeplitz(sig100, [sig100(1), zeros(1, M - 1)]);
UB_1000 = toeplitz(sig1000, [sig1000(1), zeros(1, M - 1)]);
US_100 = toeplitz(sigsin100, [sigsin100(1), zeros(1, M - 1)]);
US_1000 = toeplitz(sigsin1000, [sigsin1000(1), zeros(1, M - 1)]);
% metoda LS
h_LS_bin100 = (UB_100' * UB_100) \ (UB_100' * noiseb100');
h_LS_bin1000 = (UB_1000' * UB_1000) \ (UB_1000' * noiseb1000');
h_LS_sin100 = (US_100' * US_100) \ (US_100' * noisesin100');
h_LS_sin1000 = (US_1000' * US_1000) \ (US_1000' * noisesin1000');
% Identyfikacja korelacyjna
h_corr_bin100 = identyfikacja_korelacyjna(noiseb100, sig100, M);
h_corr_bin1000 = identyfikacja_korelacyjna(noiseb1000, sig1000, M);
h_corr_sin100 = identyfikacja_korelacyjna(noisesin100, sigsin100, M);
h_corr_sin1000 = identyfikacja_korelacyjna(noisesin1000, sigsin1000, M);
% Obliczanie MSE w stosunku do sygnałów wzorcowych
mse_bin100_LS = calculateMSE(h_LS_bin100, yb100(1:M));
mse_bin100_CORR = calculateMSE(h_corr_bin100, wzorzec(1:M));
mse_bin1000_LS = calculateMSE(h_LS_bin1000, yb1000(1:M));
mse_bin1000_CORR = calculateMSE(h_corr_bin1000, wzorzec(1:M));
mse_sin100_LS = calculateMSE(h_LS_sin100, ysin100(1:M));
mse_sin100_CORR = calculateMSE(h_corr_sin100, wzorzec(1:M));
mse_sin1000_LS = calculateMSE(h_LS_sin1000, ysin1000(1:M));
mse_sin1000_CORR = calculateMSE(h_corr_sin1000, wzorzec(1:M));
% Wyświetlanie MSE
disp('MSE dla poszczególnych przypadków:');
disp(['Binarny 100 próbek (LS): ', num2str(mse_bin100_LS)]);
disp(['Binarny 100 próbek (Korelacja): ', num2str(mse_bin100_CORR)]);
disp(['Binarny 1000 próbek (LS): ', num2str(mse_bin1000_LS)]);
disp(['Binarny 1000 próbek (Korelacja): ', num2str(mse_bin1000_CORR)]);
disp(['Sinusoidalny 100 próbek (LS): ', num2str(mse_sin100_LS)]);
disp(['Sinusoidalny 100 próbek (Korelacja): ', num2str(mse_sin100_CORR)]);
disp(['Sinusoidalny 1000 próbek (LS): ', num2str(mse_sin1000_LS)]);
disp(['Sinusoidalny 1000 próbek (Korelacja): ', num2str(mse_sin1000_CORR)]);
% Rysowanie wykresów porównawczych
x_axis = 0:M-1;
figure;
subplot(2, 2, 1);
stem(x_axis, h_LS_bin100, 'b', 'DisplayName', 'LS'); hold on;
stem(x_axis, wzorzec(1:M), 'k', 'DisplayName', 'Wzorzec'); hold on;
stem(x_axis, h_corr_bin100, 'r', 'DisplayName', 'Korelacja');
xlim([0 M]);
title('Sygnał binarny - 100 próbek');
ylabel('Amplituda');
xlabel('Numer próbki');
legend;
subplot(2, 2, 2);
stem(x_axis, h_LS_bin1000, 'b', 'DisplayName', 'LS'); hold on;
stem(x_axis, wzorzec(1:M), 'k', 'DisplayName', 'Wzorzec'); hold on;
stem(x_axis, h_corr_bin1000, 'r', 'DisplayName', 'Korelacja');
xlim([0 M]);
title('Sygnał binarny - 1000 próbek');
ylabel('Amplituda');
xlabel('Numer próbki');
legend;
subplot(2, 2, 3);
stem(x_axis, h_LS_sin100, 'b', 'DisplayName', 'LS'); hold on;
stem(x_axis, wzorzec(1:M), 'k', 'DisplayName', 'Wzorzec'); hold on;
stem(x_axis, h_corr_sin100, 'r', 'DisplayName', 'Korelacja');
xlim([0 M]);
title('Sygnał sinusoidalny - 100 próbek');
ylabel('Amplituda');
xlabel('Numer próbki');
legend;
subplot(2, 2, 4);
stem(x_axis, h_LS_sin1000, 'b', 'DisplayName', 'LS'); hold on;
stem(x_axis, wzorzec(1:M), 'k', 'DisplayName', 'Wzorzec'); hold on;
stem(x_axis, h_corr_sin1000, 'r', 'DisplayName', 'Korelacja');
xlim([0 M]);
title('Sygnał sinusoidalny - 1000 próbek');
ylabel('Amplituda');
xlabel('Numer próbki');
legend;
% Funkcja do obliczania MSE
function mse = calculateMSE(h, ref)
 if length(h) ~= length(ref)
 error('Wektory muszą mieć tę samą długość.');
 end
 mse = mean((ref - h).^2);
end
% Funkcja identyfikacji korelacyjnej
function h = identyfikacja_korelacyjna(Y, U, M)
 [Ryu, lags] = xcorr(Y, U, 'unbiased');
 [Ruu, ~] = xcorr(U, U, 'unbiased');
 Ruu_matrix = toeplitz(Ruu(length(U):length(U)+M-1));
 Ryu_vector = Ryu(length(U):length(U)+M-1)';
 h = Ruu_matrix \ Ryu_vector; 
end
% Zadanie 4
% Obiekt
K = 3; 
T = 2; 
L = 3; 
% odpowiedź skokowa
t = 0:0.1:50;
y = K * (1 - exp(-(t-L)/T)) .* (t >= L);
% Kwantyzacja 
y_q = round(((y + 5) / 10) * 255);
y_q = (y_q / 255) * 10 - 5;
% Rysowanie odpowiedzi skokowej
figure;
plot(t, y_q, 'b', 'DisplayName', 'Odpowiedź skokowa kwantyzowana'); hold on;
plot(t, y, 'g--', 'DisplayName', 'Oryginalna odpowiedź skokowa');
title('Odpowiedź skokowa systemu pierwszego rzędu z opóźnieniem');
xlabel('Czas');
ylabel('Odpowiedź');
grid on;
legend;
iter = 20000; % iteracje
zakres_param = [0, 5; % Zakresy
 0, 5; 
 0, 5]; 
naj_param = [rand() * (zakres_param(1, 2) - zakres_param(1, 1)) + zakres_param(1, 1), ...
 rand() * (zakres_param(2, 2) - zakres_param(2, 1)) + zakres_param(2, 1), ...
 rand() * (zakres_param(3, 2) - zakres_param(3, 1)) + zakres_param(3, 1)]; 
min_error = inf; 
krok_poczatkowy = 0.5; 
for i = 1:iter
 krok = krok_poczatkowy * (1 - i / iter);
 p = (rand(1, 3) - 0.5) * 2 * krok; 
 nowy_param = naj_param + p; 
 nowy_param = max(nowy_param, zakres_param(:, 1)'); % Dolna granica
 nowy_param = min(nowy_param, zakres_param(:, 2)'); % Górna granica
 y_sim = naszModel(t, nowy_param);
 y_sim_q = round(((y_sim + 5) / 10) * 255);
 y_sim_q = (y_sim_q / 255) * 10 - 5;
%błąd
 error = sum((y_q - y_sim_q).^2);
 if error < min_error
 min_error = error;
 naj_param = nowy_param;
 end
end
% Wyświetlenie najlepszych parametrów
disp('Najlepsze parametry (metoda losowa):');
disp(['K = ', num2str(naj_param(1))]);
disp(['T = ', num2str(naj_param(2))]);
disp(['L = ', num2str(naj_param(3))]);
disp(['Minimalny błąd = ', num2str(min_error)]);
% Rysowanie wyników
figure;
plot(t, y_q, 'b', 'DisplayName', 'Odpowiedź skokowa kwantyzowana'); hold on;
plot(t, naszModel(t, naj_param), 'r--', 'DisplayName', 'Odpowiedź modelu (estymowana)');
title('Porównanie odpowiedzi skokowej kwantyzowanej i modelu estymowanego');
legend;
grid on;
% metoda stycznej
[~, maxIdx] = max(diff(y) / 0.1); % maks nachylenie
styczna_nach = (y(maxIdx + 1) - y(maxIdx)) / (t(maxIdx + 1) - t(maxIdx)); 
styczna_row = styczna_nach * (t - t(maxIdx)) + y(maxIdx);
% parametry dla metody graficznej
K_graf = max(y);
T_graf = (K_graf / styczna_nach) + t(maxIdx) - L;
L_graf = t(maxIdx) - (y(maxIdx) / styczna_nach);
% Wyświetlenie parametrów 
disp('Najlepsze parametry (metoda graficzna):');
disp(['K = ', num2str(K_graf)]);
disp(['T = ', num2str(T_graf)]);
disp(['L = ', num2str(L_graf)]);
% Rysowanie – metoda graficzna
figure;
plot(t, y, 'b', 'DisplayName', 'Odpowiedź skokowa'); hold on;
plot(t, styczna_row, 'r--', 'DisplayName', 'Styczna');
title('Odpowiedź skokowa systemu z narysowaną styczną');
xlabel('Czas');
ylabel('Odpowiedź');
ylim([0 3]);
grid on;
legend;
% symulacja naszego układu
function y = naszModel(t, params)
 K = params(1);
 T = params(2);
 L = params(3);
 y = K * (1 - exp(-(t-L)/T)) .* (t >= L);
end