function [] = testSkracaniaZerBJ(model)

% [] = testSkracania(model)
%
% Wykonuje test skracania zer i biegunów dla danego MODELU, tzn. rysuje
% jego zera i bieguny na wspólnym wykresie na płaszczyźnie z.
% Przedstawia wyniki w bieżącym oknie wykresu na dwóch rysunkach 
% (subplotach) - dla toru sterowania i toru zakłócenia. 


biegunyF = roots(model.f);
biegunyD = roots(model.d);

% "model" przechowuje opóźnienie d jako d zerowych początkowych
% współczynników wielomianu B - trzeba te zera pominąć:
indeks = find( abs(model.b) > 1e-10 );  % znajdź indeks pierwszego elementu!=0
zeraB = roots( model.b(indeks:end) );
zeraC = roots(model.c);

% rysuj wykres w bieżącym oknie:
subplot(211)
zplane(zeraB(:), biegunyF(:));
title('Zera (o) i bieguny (x) toru sterowania w modelu', 'fontsize', 12);
xlabel('Re(z)');
ylabel('Im(z)');

subplot(212)
zplane(zeraC(:), biegunyD(:));
title('Zera (o) i bieguny (x) toru zakłócenia w modelu', 'fontsize', 12);
xlabel('Re(z)');
ylabel('Im(z)');
