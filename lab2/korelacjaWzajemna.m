function [] = korelacjaWzajemna(y, u)

% [] = korelacjaWzajemna(y, u)
%
% Wykreœla korelacjê wzajemn¹ sygna³ów y oraz u w bie¿¹cym oknie wykresu.


% estymuj korelacjê wzajemn¹ sygna³ów - tylko dla przesuniêæ w zakresie
% +-10% d³ugoœci sygna³ów, poniewa¿ dla wiêkszych przesuniêæ estymator
% staje siê zbyt niedok³adny:
[kor, przes] = xcorr(y, u, length(u)/10, 'unbiased');
    % opcja 'unbiased' oznacza obliczenia dla nieobci¹¿onego estymatora
    % korelacji (patrz wyk³ady)

% wykres:
stem(przes, kor);  % korelacjê wykreœlamy "punktowo" (np. stem), a nie 
    % lini¹ ci¹g³¹ (plot), bo to funkcja okreœlona tylko na dyskretnym 
    % zbiorze argumentów
hold all
plot([0 0], ylim(), 'k');  % pomocniczo: pionowa oœ wykresu
title('Korelacja wzajemna y oraz u', 'fontsize', 12);
xlabel('Przesuniêcie \tau');
ylabel('Korelacja wzajemna R_{yu}(\tau)');
