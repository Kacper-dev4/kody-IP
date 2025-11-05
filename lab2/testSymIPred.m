function [MSE_sym, MSE_pred] = testSymIPred(model, u_wer, y_wer)

% [MSE_sym, MSE_pred] = testSymIPred(model, u_wer, y_wer)
%
% Wykonuje test symulacyjny i test jednokrokowej predykcji wyjœæ dla danego
% MODELU i zestawu weryfikacyjnych danych pomiarowych z obiektu - 
% wejœciowych U_WER i wyjœciowych Y_WER. 
% Rysuje wygenerowane przebiegi na wspólnym wykresie w bie¿¹cym oknie. 
% Dodatkowo zwraca b³¹d œredniokwadratowy (MSE) obliczony dla wyjœcia
% modelu wyznaczonego obiema metodami.


% test symulacyjny:

% mo¿na go wykonaæ tak... :
%dane_wer = iddata(y_wer, u_wer, 1);
%compare( dane_wer, model )

% ... lub z u¿yciem posiadanej funkcji do generowania wyjœcia obiektu ARMAX:
[ym_sym, t] = yARMAX(0, model.a, model.b, model.c, u_wer);  
    % jeœli C==1, w efekcie zostanie zasymulowany model ARX;
    % jeœli C!=1, zostanie zasymulowany model ARMAX;
    % uwaga: 
    % MODEL zwracany przez polecenia ARX i ARMAX przechowuje
    % opóŸnienie dyskretne d jako zerowe wspó³czynniki w wielomianie B,
    % dlatego nie nale¿y powielaæ opóŸnienia w powy¿szym wywo³aniu 
    % funkcji, lecz wstawiæ 0

    
% test jednokrokowej predykcji wyjœæ:
ym_pred = predict( model, [y_wer u_wer], 1 );
% UWAGA, w starszych wersjach MATLAB-a polecenie predict zwraca wartoœæ
% jako cell - nale¿y odkomentowaæ poni¿sz¹ linijkê, aby z cella uzyskaæ
% zwyk³y wektor:
%ym_pred = ym_pred{1};


% wykresy w bie¿¹cym oknie:
plot(t, y_wer, 'k');  % dane "zmierzone"
hold all
plot(t, ym_sym, 'r:');  % wyniki testu symulacyjnego
plot(t, ym_pred, 'b:');  % wyniki testu 1-krokowej predykcji
title('Test symulacyjny i jednokrokowej predykcji wyjœæ', 'fontsize', 12);
xlabel('nr próbki');
ylabel('wyjœcie');
legend('obiekt', 'model - symulacja', 'model - predykcja');


% oblicz MSE dla obu rodzajów wyjœcia modelu:
MSE_sym  = obliczMSE(y_wer, ym_sym);
MSE_pred = obliczMSE(y_wer, ym_pred);
