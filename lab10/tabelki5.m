%% Program badający wpływ liczby neuronów na błąd MSE dla systemu nieliniowego
clear all; close all;

% Parametry modelu nieliniowego
sigma2 = 1;
a1 = -0.71; a2 = 0.36; b1 = 0.6;
c = 1.0; d = 0.1;
A = [1 a1 a2]; B = [0 b1];
dBn = 1; dAn = 2;
trainFcn = 'trainbr'; % Bayesian Regulation - dobrze radzi sobie z nieliniowościami

% Parametry eksperymentu
N_values = [1000, 10000];
neuron_counts = [5, 10, 20, 40, 50]; 

% Macierz na wyniki
results_mse = zeros(length(neuron_counts), length(N_values));

for j = 1:length(N_values)
    N = N_values(j);
    fprintf('Analiza dla N = %d...\n', N);
    
    % Generowanie sygnałów (z uwzględnieniem nieliniowości)
    us_raw = sqrt(sigma2) * randn(N, 1);
    v = filter(B, A, us_raw);
    ys_raw = c*v + d*v.^3; % System nieliniowy
    
    % Konwersja na format dla sieci neuronowej
    us_cell = num2cell(us_raw');
    ys_cell = num2cell(ys_raw');
    
    for i = 1:length(neuron_counts)
        L = neuron_counts(i);
        fprintf('  - Trenowanie sieci: %d neuronów\n', L);
        
        % Inicjalizacja sieci NARX
        inputDelays = 0:dBn;
        feedbackDelays = 1:dAn;
        net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
        
        % Konfiguracja parametrów uczenia
        net.trainParam.showWindow = false; % Ukrycie okien dla szybkości
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;
        
        % Przygotowanie danych i trening
        [x, xi, ai, t] = preparets(net, us_cell, {}, ys_cell);
        [net, tr] = train(net, x, t, xi, ai);
        
        % Obliczenie błędu MSE
        y_pred = net(x, xi, ai);
        results_mse(i, j) = perform(net, t, y_pred);
    end
end

% Generowanie tabeli wynikowej
TabelaWynikow = table(neuron_counts', results_mse(:,1), results_mse(:,2), ...
    'VariableNames', {'Liczba_Neuronow', 'MSE_N_1000', 'MSE_N_10000'});

disp('--- TABELA WYNIKÓW DLA SYSTEMU NIELINIOWEGO ---');
disp(TabelaWynikow);

% Wykres porównawczy
figure;
semilogy(neuron_counts, results_mse(:,1), '-o', 'LineWidth', 1.5); hold on;
semilogy(neuron_counts, results_mse(:,2), '-s', 'LineWidth', 1.5);
grid on;
xlabel('Liczba neuronów w warstwie ukrytej');
ylabel('Błąd średniokwadratowy (MSE)');
title('Wpływ złożoności sieci na jakość modelu nieliniowego');
legend('N = 1000', 'N = 10000');