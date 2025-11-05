function mse = obliczMSE(y_ob, y_m)

% mse = obliczMSE(y_ob, y_m)
%
% Oblicza b³¹d œredniokwadratowy (Mean Squared Error, MSE) dla podanych
% wektorów próbek wyjœcia obiektu Y_OB i wyjœcia modelu Y_M.


if ~isequal( size(y_ob), size(y_m) )
    error('Wyjœcia obiektu i modelu musz¹ mieæ taki sam rozmiar.');
end

mse = mean( (y_ob-y_m).^2 );
