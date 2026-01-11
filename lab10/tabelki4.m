%% Program do generowania tabeli MSE dla różnych N i liczby neuronów
clear all; close all;

% Parametry stałe
sigma2 = 1;
a1 = -1.2; a2 = 0.36; b1 = 0.6;
A = [1 a1 a2]; B = [0 b1];
dBn = 1; dAn = 2;
trainFcn = 'trainlm'; % Bayesian Regulation

% Definicja badanych przypadków
N_values = [1000, 10000];
neuron_counts = [5, 10, 20, 40, 50]; % 6 różnych wartości

% Prealokacja macierzy na wyniki MSE
% Wiersze: liczba neuronów, Kolumny: różne wartości N
results_mse = zeros(length(neuron_counts), length(N_values));

for j = 1:length(N_values)
    N = N_values(j);
    fprintf('Obliczenia dla N = %d...\n', N);
    
    % Generowanie sygnałów
    us_raw = sqrt(sigma2)*randn(N,1);
    ys_raw = filter(B, A, us_raw);
    
    % Konwersja na format komórkowy dla sieci neuronowej
    us = num2cell(us_raw');
    ys = num2cell(ys_raw');
    
    for i = 1:length(neuron_counts)
        L = neuron_counts(i);
        fprintf('  - Liczba neuronów: %d\n', L);
        
        % Definicja sieci NARX
        inputDelays = 0:dBn;
        feedbackDelays = 1:dAn;
        net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
        
        % Przygotowanie danych (wyłączenie wyświetlania okna uczenia dla szybkości)
        net.trainParam.showWindow = false; 
        [x, xi, ai, t] = preparets(net, us, {}, ys);
        
        % Podział danych
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;
        
        % Uczenie sieci
        [net, tr] = train(net, x, t, xi, ai);
        
        % Testowanie i obliczenie MSE
        y_pred = net(x, xi, ai);
        results_mse(i, j) = perform(net, t, y_pred);
    end
end

% Tworzenie i wyświetlanie tabeli wyników
TabelaWynikow = table(neuron_counts', results_mse(:,1), results_mse(:,2), ...
    'VariableNames', {'Liczba_Neuronow', 'MSE_N_1000', 'MSE_N_10000'});

disp('--- WYNIKI KOŃCOWE ---');
disp(TabelaWynikow);

% Opcjonalnie: Wykres porównawczy
figure;
plot(neuron_counts, results_mse(:,1), '-o', 'LineWidth', 2);
hold on;
plot(neuron_counts, results_mse(:,2), '-s', 'LineWidth', 2);
grid on;
xlabel('Liczba neuronów');
ylabel('MSE');
title('Porównanie błędu MSE w zależności od N i liczby neuronów');
legend('N = 1000', 'N = 10000');