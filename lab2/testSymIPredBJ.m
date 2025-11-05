function [MSE_sym, MSE_pred] = testSymIPredBJ(model, u_wer, y_wer)

% [MSE_sym, MSE_pred] = testSymIPred(model, u_wer, y_wer)
%
% Wykonuje test symulacyjny i test jednokrokowej predykcji wyjść dla danego
% MODELU i zestawu weryfikacyjnych danych pomiarowych z obiektu - 
% wejściowych U_WER i wyjściowych Y_WER. 
% Rysuje wygenerowane przebiegi na wspólnym wykresie w bieżącym oknie. 
% Dodatkowo zwraca błąd średniokwadratowy (MSE) obliczony dla wyjścia
% modelu wyznaczonego obiema metodami.


% test symulacyjny:

% można go wykonać tak... :
%dane_wer = iddata(y_wer, u_wer, 1);
%compare( dane_wer, model )

% ... lub z użyciem posiadanej funkcji do generowania wyjścia obiektu ARMAX:
[ym_sym, t] = yBJ(0, model.b, model.c, model.d, model.f, u_wer);  
    % jeśli C==1, w efekcie zostanie zasymulowany model ARX;
    % jeśli C!=1, zostanie zasymulowany model ARMAX;
    % uwaga: 
    % MODEL zwracany przez polecenia ARX i ARMAX przechowuje
    % opóźnienie dyskretne d jako zerowe współczynniki w wielomianie B,
    % dlatego nie należy powielać opóźnienia w powyższym wywołaniu 
    % funkcji, lecz wstawić 0

    
% test jednokrokowej predykcji wyjść:
ym_pred = predict( model, [y_wer u_wer], 1 );
% UWAGA, w starszych wersjach MATLAB-a polecenie predict zwraca wartość
% jako cell - należy odkomentować poniższą linijkę, aby z cella uzyskać
% zwykły wektor:
%ym_pred = ym_pred{1};


% wykresy w bieżącym oknie:
plot(t, y_wer, 'k');  % dane "zmierzone"
hold all
plot(t, ym_sym, 'r:');  % wyniki testu symulacyjnego
plot(t, ym_pred, 'b:');  % wyniki testu 1-krokowej predykcji
title('Test symulacyjny i jednokrokowej predykcji wyjść', 'fontsize', 12);
xlabel('nr próbki');
ylabel('wyjście');
legend('obiekt', 'model - symulacja', 'model - predykcja');


% oblicz MSE dla obu rodzajów wyjścia modelu:
MSE_sym  = obliczMSE(y_wer, ym_sym);
MSE_pred = obliczMSE(y_wer, ym_pred);
