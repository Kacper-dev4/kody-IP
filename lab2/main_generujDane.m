% Laboratorium Identyfikacji Procesów
% r. akad. 2016/17
%
% Kod pomocniczy do æwiczenia 2: Parametryczne dynamiczne modele liniowe


clear 
%close all


% ------- Wybór parametrów obiektu -------
% Zasymulujemy rzeczywisty obiekt za pomoc¹ modelu ARMAX.
% Wówczas bêdzie mo¿na ³atwiej sprawdziæ poprawnoœæ identyfikacji, ni¿
% gdybyœmy u¿yli sygna³ów pomiarowych z faktycznego obiektu rzeczywistego.

d = 2;  % opóŸnienie dyskretne w obiekcie
A = [1 -0.5 -0.7 0.5];  % wiel. A; uwaga, pierwszy wspó³czynnik musi byæ równy 1
B = [0.7 0.3];  % wiel. B; pierwszy wspó³czynnik - dowolny
% w wielomianie C pierwszy wspó³czynnik musi byæ równy 1:
%C = 1;  % C==1 -> model ARX
C = [1 -0.7 0.3];  % C!=1 -> model ARMAX

N = 1000;  % liczba próbek, któr¹ chcemy uzyskaæ (sumaryczna dla danych 
    % do identyfikacji i do weryfikacji)

% --------------------- koniec danych podawanych przez u¿ytkownika

% nale¿y upewniæ siê, ¿e wybrany obiekt jest stabilny oraz ¿e wielomian C
% ma pierwiastki wewn¹trz okrêgu jednostkowego; mo¿na zbadaæ tak¿e 
% minimalnofazowoœæ obiektu (czyli po³o¿enie pierwiastków wielomianu B):
bieguny = roots(A);  % pierwiastki wielomianu A, poni¿ej B i C
zeraB = roots(B);
zeraC = roots(C);

figure
subplot(211)
    zplane(zeraB(:), bieguny(:));  % (:) = zapewnij wektory kolumnowe
    title('Zera (o) i bieguny (x) toru sterowania w obiekcie', 'fontsize', 12);
    xlabel('Re(z)');
    ylabel('Im(z)');
subplot(212)
    zplane(zeraC(:), bieguny(:));  % bieguny toru zak³ócenia s¹ takie same, jak toru sterowania
    title('Zera (o) i bieguny (x) toru zak³ócenia w obiekcie', 'fontsize', 12);
    xlabel('Re(z)');
    ylabel('Im(z)');
% PS. zobacz: help zplane, aby przeczytaæ wyjaœnienie u¿ycia wektorów
% wierszowych i kolumnowych w poleceniu zplane


% ------- Generacja danych "pomiarowych" -------
% Symulacja zbierania pomiarów z rzeczywistego obiektu.

% sygna³ wejœciowy:
u = randn(N, 1)*10;  % pobudzenie szumem (o wybranym odchyleniu stand.)
    % - du¿a zmiennoœæ sygna³u pobudzaj¹cego stwarza dobre warunki do 
    % prowadzenia identyfikacji

% odpowiedŸ obiektu na takie pobudzenie:
y = yARMAX(d, A, B, C, u);

% podziel zebrane przebiegi na dwa zbiory - dane do identyfikacji oraz dane
% do weryfikacji modelu; mog¹ byæ ró¿nej d³ugoœci (zazwyczaj do
% identyfikacji u¿ywamy d³u¿szego fragmentu), mog¹ byæ równe:
%     - dane do identyfikacji modelu:
u_id = u(1:end/2);
y_id = y(1:end/2);
%     - dane do weryfikacji modelu:
u_wer = u(end/2+1:end);
y_wer = y(end/2+1:end);


% ------- Zapis danych do pliku -------

% zapisz dane - parametry modelu i wygenerowane sygna³y - by póŸniej 
% wykorzystywaæ te same przebiegi sygna³ów do identyfikacji wielu ró¿nych
% modeli:
save('pomiaryZnanyObiekt');
