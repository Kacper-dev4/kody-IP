function [y, t] = yARMAX(d, A, B, C, u)

% [y, t] = yARMAX(d, A, B, C, u)
%
% Zwraca odpowiedŸ Y stacjonarnego obiektu typu ARMAX na pobudzenie U: 
%             B(z^-1)        C(z^-1)
% y(i) = z^-d ------- u(i) + ------- e(i)
%             A(z^-1)        A(z^-1)
% oraz chwile próbkowania T.
% 
% U¿ycie C=1 jest równowa¿ne symulacji obiektu typu ARX.


% liczba próbek sterowania i oczekiwana liczba próbek wyjœcia:
N = length(u);

% chwile próbkowania:
t = 0 : N-1;  % okres próbkowania: 1

% bia³y szum do modelowania zak³ócenia - uwaga, nie wystêpuje jako fizyczny 
% sygna³, zatem jest niemierzalny, dlatego nie jest zwracany na zewn¹trz 
% funkcji:
e = randn(N, 1);  % randn() zwraca wartoœæ losow¹ o rozk³adzie normalnym, nie myliæ z rand()

% obiekt dynamiczny tworzy siê przez:
% obiekt = tf( licznik, mianownik, okres_próbkowania, [opcje] );
% tu potrzebny jest obiekt "o wielu wejœciach" (u oraz e), st¹d licznik
% i mianownik musz¹ byæ podane jako macierze typu cell {} 
% (wiêcej informacji: help tf)
obiekt = tf({B C}, {A A}, 1, 'variable', 'z^-1', 'inputDelay', [d 0]);

% symuluj wyjœcie obiektu:
y = lsim(obiekt, [u e], t);
