% ------- Automatyczne przeszukiwanie modeli ARMAX -------

dane_ident = iddata(y_id, u_id, 1);

results = []; % tablica do przechowywania wyników

% Zakresy przeszukiwania
for dAm = 1:5
    for dBm = 1:5
        for dCm = 1:5
            for dm = 1:4
                try
                    % Identyfikacja modelu
                    model = armax(dane_ident, [dAm dBm dCm dm]);

                    % Testy weryfikacyjne
                    [MSE_sym, MSE_pred] = testSymIPred(model, u_wer, y_wer);

                    % Obliczenie AIC i BIC
                    N = length(u_id);
                    S = MSE_pred;
                    dk = numel(getpvec(model));
                    [AIC, BIC] = liczenieAIC_BIC(N, S, dk);

                    % Zapis wyników
                    results = [results; dAm dBm dCm dm AIC BIC MSE_pred MSE_sym];

                    fprintf('Model ARMAX(%d,%d,%d,%d): AIC=%.3f, BIC=%.3f, MSE_pred=%.5f, MSE_sym=%.5f\n', ...
                        dAm, dBm, dCm, dm, AIC, BIC, MSE_pred, MSE_sym);

                catch ME
                    % Pominięcie modeli, które nie dają się zidentyfikować
                    fprintf('Błąd dla (%d,%d,%d,%d): %s\n', dAm, dBm, dCm, dm, ME.message);
                end
            end
        end
    end
end

% Utworzenie tabeli wyników
wyniki = array2table(results, ...
    'VariableNames', {'dAm','dBm','dCm','dm','AIC','BIC','MSE_pred','MSE_sym'});

% Wyświetlenie tabeli w Command Window
disp('----------------------------------------------------------');
disp('Wyniki przeszukiwania modeli ARMAX:');
disp(wyniki);

% Dla chętnych – można też posortować po najmniejszym AIC lub MSE_pred:
wyniki_sort_AIC = sortrows(wyniki, 'AIC');
disp('Najlepsze modele wg AIC:');
disp(wyniki_sort_AIC(1:10,:));

wyniki_sort_MSE = sortrows(wyniki, 'MSE_pred');
disp('Najlepsze modele wg MSE_pred:');
disp(wyniki_sort_MSE(1:10,:));
