% Laboratorium Identyfikacji Procesów
% r. akad. 2016/17
%
% Kod pomocniczy do æwiczenia 2: Parametryczne dynamiczne modele liniowe
clear all
close all

%clear
%close all


% ------- Dane o obiekcie i o modelu -------

% wczytaj sygna³y wejœciowe i wyjœciowe (oraz prawdziwe parametry obiektu,
% jeœli s¹ znane):
%load('pomiaryZnanyObiekt');
load('nieznanyObiekt7.mat');

% dAm = 5;  % stopieñ wielomianu A w modelu
% dBm = 3;  % stopieñ wielomianu B w modelu
% dCm = 3;  % stopieñ wielomianu C w modelu
% dm = 2;   % opóŸnienie w modelu


% po¿¹dana struktura modelu:
dAm = 4;  % stopieñ wielomianu A w modelu
dBm = 3;  % stopieñ wielomianu B w modelu
dCm = 1;  % stopieñ wielomianu C w modelu
dm = 2;   % opóŸnienie w modelu



% struktura modelu Box Jenkins

% nb = 3; % stopieñ wielomianu B w modelu
% nc = 1; % stopieñ wielomianu C w modelu
% nd = 4; % stopieñ wielomianu D w modelu
% nf = 4; % stopieñ wielomianu F w modelu
% nk = 2; % opóŸnienie modelu

nb = 3; % stopieñ wielomianu B w modelu
nc = 2; % stopieñ wielomianu C w modelu
nd = 3; % stopieñ wielomianu D w modelu
nf = 4; % stopieñ wielomianu F w modelu
nk = 2; % opóŸnienie modelu

% --------------------- koniec danych podawanych przez u¿ytkownika


% ------- Korelacja wzajemna wyjœcia obiektu i sterowania -------
% Wykreœlenie korelacji wzajemnej tych sygna³ów pozwala zaobserwowaæ 
% wartoœæ opóŸnienia d w obiekcie. Pierwsza znacz¹ca wartoœæ korelacji
% (znacznie ró¿na od zera) pojawia siê na wykresie dopiero dla
% przesuniêcia równego d.
% Tê w³aœciwoœæ warto wykorzystaæ do wybrania d w modelu, gdy pracujemy na
% zbiorze pomiarów z nieznanego obiektu.

figure('name', 'Korelacja');
korelacjaWzajemna(y_id, u_id);


% ------- Identyfikacja modelu -------
% Identyfikuj model o zadanej strukturze i wypisz efekty w oknie poleceñ.

% Uwaga: funkcje ARX i ARMAX nie przyjmuj¹ bezpoœrednio stopni wielomianów,
% lecz liczbê parametrów w wielomianach, które nale¿y zidentyfikowaæ.
% W wielomianie A znamy wyraz pocz¹tkowy a_0=1, zatem trzeba zidentyfikowaæ
% tylko wspó³czynniki a_1:a_dAm (razem: dAm sztuk). 
% Podobnie dla wielomianu C.
% W wielomianie B trzeba zidentyfikowaæ tak¿e wspó³czynnik b0, który mo¿e
% byæ dowolny, zatem nale¿y obliczyæ dBm+1 wspó³czynników.

dane_ident = iddata(y_id, u_id, 1);
model = arx(dane_ident, [dAm dBm dm])  % identyfikuj model ARX
%model = armax(dane_ident, [dAm dBm dCm dm])  % identyfikuj model ARMAX
%model = bj(dane_ident,[nb nc nd nf nk])
% dla chêtnych: identyfikacja modelu Boxa-Jenkinsa (zobacz: help bj) lub
% output error (zobacz: help oe); 
% uwaga, to wymaga korekt w kodzie weryfikuj¹cym model!
%............


% ------- Weryfikacja modelu -------

% porównaj dane weryfikacyjne (nie dane, które s³u¿y³y do identyfikacji!)
% i wyjœcie modelu:

% test symulacyjny i test jednokrokowej predykcji wyjœæ - na wspólnym
% wykresie, by mo¿na je ³atwo porównaæ - wraz z obliczeniem MSE:
figure('name', 'Test symulacyjny i test predykcji');
%
%
[MSE_sym, MSE_pred] = testSymIPred(model, u_wer, y_wer); % ARX ARMAX%
%[MSE_sym, MSE_pred] = testSymIPredBJ(model, u_wer, y_wer); % BJ
display(MSE_sym);
display(MSE_pred);
    
% test bia³oœci b³êdów predykcji:
figure('name', 'Test bia³oœci');
testBialosci(model, u_wer, y_wer);

% test skracania zer i biegunów:
figure('name', 'Test skracania');
testSkracania(model);    % ARX i ARMAX
%testSkracaniaZerBJ(model) % zmieniona wersja testu skracania zer i biegunów dla BJ

% dla chêtnych: oblicz wartoœci kryteriów informacyjnych (AIC, BIC)
N = length(u_id);
S = MSE_pred;
dk = numel(getpvec(model));

[AIC, BIC] = liczenieAIC_BIC(N, S, dk)
