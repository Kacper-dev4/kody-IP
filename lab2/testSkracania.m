function [] = testSkracania(model)

% [] = testSkracania(model)
%
% Wykonuje test skracania zer i biegunÛw dla danego MODELU, tzn. rysuje
% jego zera i bieguny na wspÛlnym wykresie na p≥aszczyünie z.
% Przedstawia wyniki w bieøπcym oknie wykresu na dwÛch rysunkach 
% (subplotach) - dla toru sterowania i toru zak≥Ûcenia. 


bieguny = roots(model.a);

% "model" przechowuje opÛünienie d jako d zerowych poczπtkowych
% wspÛ≥czynnikÛw wielomianu B - trzeba te zera pominπÊ:
indeks = find( abs(model.b) > 1e-10 );  % znajdü indeks pierwszego elementu!=0
zeraB = roots( model.b(indeks:end) );

zeraC = roots(model.c);

% rysuj wykres w bieøπcym oknie:
subplot(211)
zplane(zeraB(:), bieguny(:));
title('Zera (o) i bieguny (x) toru sterowania w modelu', 'fontsize', 12);
xlabel('Re(z)');
ylabel('Im(z)');

subplot(212)
zplane(zeraC(:), bieguny(:));
title('Zera (o) i bieguny (x) toru zak≥Ûcenia w modelu', 'fontsize', 12);
xlabel('Re(z)');
ylabel('Im(z)');
