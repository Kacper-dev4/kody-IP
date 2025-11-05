function [] = testBialosci(model, u_wer, y_wer)

% [] = testBialosci(model, u_wer, y_wer)
%
% Wykonuje test bia³oœci b³êdów predykcji dla danego MODELU i zestawu
% weryfikacyjnych danych pomiarowych wejœcia i wyjœcia obiektu U_WER
% i Y_WER. 
% Przedstawia wyniki na wykresie w bie¿¹cym oknie. 


% --- wersja rozbudowana funkcji: "co siê w³aœciwie dzieje w metodzie?" ---


% wyznacz wyjœcie modelu dla predykcji 1-krokowej:
ym_pred = predict( model, [y_wer u_wer], 1 );
% UWAGA, w starszych wersjach MATLAB-a polecenie predict zwraca wartoœæ
% jako cell - nale¿y odkomentowaæ poni¿sz¹ linijkê, aby z cella uzyskaæ
% zwyk³y wektor:
%ym_pred = ym_pred{1};

% oblicz b³êdy predykcji:
eps = y_wer - ym_pred;  % wyjœcie obiektu minus wyjœcie modelu (predykowane!)

% estymuj autokorelacjê b³êdów predykcji:
N = length(eps);
M = floor(N/10);  % przyjmuje siê, ¿e wykreœlanie autokorelacji
                  % liczonej z próby ma sens dla przesuniêæ do +- N/10
[autokor, przesuniecia] = xcorr(eps, M, 'coeff');  
    % opcja 'coeff' w³¹cza normalizacjê R(0) = 1

% wykres w bie¿¹cym oknie:

% uwaga 1:
% autokorelacja jest sekwencj¹ liczb dla dyskretnych przesuniêæ,
% dlatego nie nale¿y jej rysowaæ lini¹ ci¹g³¹, lecz jako zbiór
% dyskretnych punktów
% uwaga 2:
% mo¿na te¿ rysowaæ wykres tylko dla przesuniêæ >=0, bo autokorelacja 
% jest symetryczna
stem(przesuniecia, autokor);  % autokorelacja
hold all
zakres = 3/sqrt(N);
plot( [xlim NaN xlim], [1 1 NaN -1 -1] * zakres, 'k');  % +-zakres, 
                                       % w którym ma siê zmieœciæ autokor.
title('Test bia³oœci b³êdów predykcji', 'fontsize', 12);
xlabel('przesuniêcie \tau');
ylabel('autokorelacja b³. pred. R_{\epsilon\epsilon}(\tau)');
legend('R_{\epsilon\epsilon}(\tau)', 'dopuszczalny zakres dla \tau\neq0');
legend('location', 'best');


% --- alternatywnie - wersja skrócona funkcji: polecenie MATLAB-a resid ---
% (zobacz: help resid)
%
%N = length(u_wer);
%M = floor(N/10);
%dane_wer = iddata(y_wer, u_wer, 1);
%resid(model, dane_wer, 'corr', M);  % interesuje nas pierwszy wykres
