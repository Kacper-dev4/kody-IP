% %% Program do generowania tabeli MSE dla różnych N i liczby neuronów
% clear all; close all;
% 
% % Parametry stałe
% sigma2 = 1;
% a1 = -1.2; a2 = 0.36; b1 = 0.6;
% A = [1 a1 a2]; B = [0 b1];
% dBn = 1; dAn = 2;
% trainFcn = 'trainlm'; % Bayesian Regulation
% 
% % Definicja badanych przypadków
% N_values = [1000, 10000];
% neuron_counts = [5, 10, 20, 40, 50]; % 6 różnych wartości
% 
% % Prealokacja macierzy na wyniki MSE
% % Wiersze: liczba neuronów, Kolumny: różne wartości N
% results_mse = zeros(length(neuron_counts), length(N_values));
% 
% for j = 1:length(N_values)
%     N = N_values(j);
%     fprintf('Obliczenia dla N = %d...\n', N);
% 
%     % Generowanie sygnałów
%     us_raw = sqrt(sigma2)*randn(N,1);
%     ys_raw = filter(B, A, us_raw);
% 
%     % Konwersja na format komórkowy dla sieci neuronowej
%     us = num2cell(us_raw');
%     ys = num2cell(ys_raw');
% 
%     for i = 1:length(neuron_counts)
%         L = neuron_counts(i);
%         fprintf('  - Liczba neuronów: %d\n', L);
% 
%         % Definicja sieci NARX
%         inputDelays = 0:dBn;
%         feedbackDelays = 1:dAn;
%         net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
% 
%         % Przygotowanie danych (wyłączenie wyświetlania okna uczenia dla szybkości)
%         net.trainParam.showWindow = false; 
%         [x, xi, ai, t] = preparets(net, us, {}, ys);
% 
%         % Podział danych
%         net.divideParam.trainRatio = 70/100;
%         net.divideParam.valRatio = 15/100;
%         net.divideParam.testRatio = 15/100;
% 
%         % Uczenie sieci
%         [net, tr] = train(net, x, t, xi, ai);
% 
%         % Testowanie i obliczenie MSE
%         y_pred = net(x, xi, ai);
%         results_mse(i, j) = perform(net, t, y_pred);
%     end
% end
% 
% % Tworzenie i wyświetlanie tabeli wyników
% TabelaWynikow = table(neuron_counts', results_mse(:,1), results_mse(:,2), ...
%     'VariableNames', {'Liczba_Neuronow', 'MSE_N_1000', 'MSE_N_10000'});
% 
% disp('--- WYNIKI KOŃCOWE ---');
% disp(TabelaWynikow);
% 
% % Opcjonalnie: Wykres porównawczy
% figure;
% plot(neuron_counts, results_mse(:,1), '-o', 'LineWidth', 2);
% hold on;
% plot(neuron_counts, results_mse(:,2), '-s', 'LineWidth', 2);
% grid on;
% xlabel('Liczba neuronów');
% ylabel('MSE');
% title('Porównanie błędu MSE w zależności od N i liczby neuronów');
% legend('N = 1000', 'N = 10000');
% 


%% Program: Przegląd zupełny dAn i dBn z KWANTYZACJĄ (Zadanie 4)
clear all; close all; clc;

% --- Parametry stałe obiektu ---
sigma2 = 1;
a1 = -1.2; a2 = 0.36; b1 = 0.6;
A = [1 a1 a2]; B = [0 b1];

% --- Konfiguracja Kwantyzatora (16-bit) ---
% Zakładamy zakres sygnału od -5 do 5 (szerokość 10)
range = 10;
levels = 2^16;
quantize = @(sig) round(sig * (levels/range)) * (range/levels);

% --- Parametry eksperymentu ---
L = 10; % Liczba neuronów
trainFcn = 'trainbr'; 
dAn_range = 1:4; % Zakres sprawdzanych rzędów
dBn_range = 1:4;
N_values = [1000, 10000];

all_results = cell(1, length(N_values));

for n_idx = 1:length(N_values)
    N = N_values(n_idx);
    fprintf('\n>>> Obliczenia dla N = %d (z kwantyzacją) <<<\n', N);
    
    % 1. Generowanie sygnału wejściowego
    us_raw = sqrt(sigma2) * randn(N,1);
    
    % 2. Generowanie sygnału wyjściowego i KWANTYZACJA
    ys_ideal = filter(B, A, us_raw);
    ys_quantized = quantize(ys_ideal); % To co widzi system akwizycji
    
    % Sprawdzenie czy sygnał mieści się w zakresie -5 do 5 (wymóg zadania)
    if max(abs(ys_quantized)) > 5
        warning('Sygnał wykracza poza zakres -5:5! Zmniejsz wzmocnienie obiektu.');
    end
    
    % Przygotowanie dla sieci
    us = num2cell(us_raw');
    ys = num2cell(ys_quantized');
    
    mse_matrix = zeros(length(dAn_range), length(dBn_range));
    
    for i = 1:length(dAn_range)
        for j = 1:length(dBn_range)
            curr_dAn = dAn_range(i);
            curr_dBn = dBn_range(j);
            
            % Konfiguracja sieci NARX
            inputDelays = 0:curr_dBn;
            feedbackDelays = 1:curr_dAn;
            net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
            
            % Ustawienia uczenia (wyciszenie okien, podział danych)
            net.trainParam.showWindow = false; 
            net.divideParam.trainRatio = 0.7;
            net.divideParam.valRatio = 0.15;
            net.divideParam.testRatio = 0.15;
            
            % Przygotowanie szeregów czasowych
            [x, xi, ai, t] = preparets(net, us, {}, ys);
            
            % Uczenie
            [net, ~] = train(net, x, t, xi, ai);
            
            % Obliczenie MSE
            y_pred = net(x, xi, ai);
            mse_matrix(i, j) = perform(net, t, y_pred);
            
            fprintf('  dAn=%d, dBn=%d | MSE: %e\n', curr_dAn, curr_dBn, mse_matrix(i,j));
        end
    end
    all_results{n_idx} = mse_matrix;
end

% --- WIZUALIZACJA I ANALIZA ---
for n_idx = 1:length(N_values)
    N = N_values(n_idx);
    
    Tabela = array2table(all_results{n_idx}, ...
        'VariableNames', cellstr("dBn_" + string(dBn_range)), ...
        'RowNames', cellstr("dAn_" + string(dAn_range)));
    
    fprintf('\n==================================================\n');
    fprintf('   WYNIKI MSE DLA N = %d\n', N);
    fprintf('==================================================\n');
    disp(Tabela);
    
    figure;
    h = heatmap(dBn_range, dAn_range, all_results{n_idx});
    h.Title = ['Błąd MSE (Z kwantyzacją) dla N = ' num2str(N)];
    h.XLabel = 'Opóźnienie wejścia (dBn)';
    h.YLabel = 'Opóźnienie sprzężenia (dAn)';
    h.Colormap = parula; 
end
