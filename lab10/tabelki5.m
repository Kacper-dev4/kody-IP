% % %% Program badający wpływ liczby neuronów na błąd MSE dla systemu nieliniowego
% % clear all; close all;
% % 
% % % Parametry modelu nieliniowego
% % sigma2 = 1;
% % a1 = -0.71; a2 = 0.36; b1 = 0.6;
% % c = 1.0; d = 0.1;
% % A = [1 a1 a2]; B = [0 b1];
% % dBn = 1; dAn = 2;
% % trainFcn = 'trainbr'; % Bayesian Regulation - dobrze radzi sobie z nieliniowościami
% % 
% % % Parametry eksperymentu
% % N_values = [1000, 10000];
% % neuron_counts = [5, 10, 20, 40, 50]; 
% % 
% % % Macierz na wyniki
% % results_mse = zeros(length(neuron_counts), length(N_values));
% % 
% % for j = 1:length(N_values)
% %     N = N_values(j);
% %     fprintf('Analiza dla N = %d...\n', N);
% % 
% %     % Generowanie sygnałów (z uwzględnieniem nieliniowości)
% %     us_raw = sqrt(sigma2) * randn(N, 1);
% %     v = filter(B, A, us_raw);
% %     ys_raw = c*v + d*v.^3; % System nieliniowy
% % 
% %     % Konwersja na format dla sieci neuronowej
% %     us_cell = num2cell(us_raw');
% %     ys_cell = num2cell(ys_raw');
% % 
% %     for i = 1:length(neuron_counts)
% %         L = neuron_counts(i);
% %         fprintf('  - Trenowanie sieci: %d neuronów\n', L);
% % 
% %         % Inicjalizacja sieci NARX
% %         inputDelays = 0:dBn;
% %         feedbackDelays = 1:dAn;
% %         net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
% % 
% %         % Konfiguracja parametrów uczenia
% %         net.trainParam.showWindow = false; % Ukrycie okien dla szybkości
% %         net.divideParam.trainRatio = 70/100;
% %         net.divideParam.valRatio = 15/100;
% %         net.divideParam.testRatio = 15/100;
% % 
% %         % Przygotowanie danych i trening
% %         [x, xi, ai, t] = preparets(net, us_cell, {}, ys_cell);
% %         [net, tr] = train(net, x, t, xi, ai);
% % 
% %         % Obliczenie błędu MSE
% %         y_pred = net(x, xi, ai);
% %         results_mse(i, j) = perform(net, t, y_pred);
% %     end
% % end
% % 
% % % Generowanie tabeli wynikowej
% % TabelaWynikow = table(neuron_counts', results_mse(:,1), results_mse(:,2), ...
% %     'VariableNames', {'Liczba_Neuronow', 'MSE_N_1000', 'MSE_N_10000'});
% % 
% % disp('--- TABELA WYNIKÓW DLA SYSTEMU NIELINIOWEGO ---');
% % disp(TabelaWynikow);
% % 
% % % Wykres porównawczy
% % figure;
% % semilogy(neuron_counts, results_mse(:,1), '-o', 'LineWidth', 1.5); hold on;
% % semilogy(neuron_counts, results_mse(:,2), '-s', 'LineWidth', 1.5);
% % grid on;
% % xlabel('Liczba neuronów w warstwie ukrytej');
% % ylabel('Błąd średniokwadratowy (MSE)');
% % title('Wpływ złożoności sieci na jakość modelu nieliniowego');
% % legend('N = 1000', 'N = 10000');
% 
% 
% %% Program: Przegląd zupełny dAn i dBn dla systemu nieliniowego
% clear all; close all;
% 
% % Parametry modelu nieliniowego
% sigma2 = 1;
% a1 = -0.71; a2 = 0.36; b1 = 0.6;
% c = 1.0; d = 0.1;
% A = [1 a1 a2]; B = [0 b1];
% 
% % Parametry eksperymentu
% L = 10;           % Stała liczba neuronów
% N = 5000;         % Stała liczba próbek
% trainFcn = 'trainbr'; 
% 
% % Zakresy przeglądu zupełnego (od 1 do 5)
% dAn_range = 1:5;
% dBn_range = 1:5;
% 
% % Macierz na wyniki MSE (wiersze: dAn, kolumny: dBn)
% mse_matrix = zeros(length(dAn_range), length(dBn_range));
% 
% % Generowanie sygnałów
% us_raw = sqrt(sigma2) * randn(N, 1);
% v = filter(B, A, us_raw);
% ys_raw = c*v + d*v.^3; % System nieliniowy
% 
% us_cell = num2cell(us_raw');
% ys_cell = num2cell(ys_raw');
% 
% fprintf('Rozpoczynam przegląd zupełny dla systemu nieliniowego (N=%d)...\n', N);
% 
% for i = 1:length(dAn_range)
%     for j = 1:length(dBn_range)
%         curr_dAn = dAn_range(i);
%         curr_dBn = dBn_range(j);
% 
%         fprintf('  Testowanie dAn=%d, dBn=%d...\n', curr_dAn, curr_dBn);
% 
%         % Konfiguracja sieci
%         inputDelays = 0:curr_dBn;
%         feedbackDelays = 1:curr_dAn;
%         net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
% 
%         net.trainParam.showWindow = false;
%         net.divideParam.trainRatio = 75/100;
%         net.divideParam.valRatio = 0/100; % trainbr nie wymaga walidacji
%         net.divideParam.testRatio = 25/100;
% 
%         % Przygotowanie danych i trening
%         [x, xi, ai, t] = preparets(net, us_cell, {}, ys_cell);
%         [net, tr] = train(net, x, t, xi, ai);
% 
%         % Obliczenie MSE
%         y_pred = net(x, xi, ai);
%         mse_matrix(i, j) = perform(net, t, y_pred);
%     end
% end
% 
% % Wyświetlanie wyników w formie tabeli
% TabelaFinal = array2table(mse_matrix, ...
%     'VariableNames', cellstr("dBn_" + string(dBn_range)), ...
%     'RowNames', cellstr("dAn_" + string(dAn_range)));
% 
% disp('--- TABELA MSE (Wiersze: dAn, Kolumny: dBn) ---');
% disp(TabelaFinal);
% 
% % Wizualizacja - Mapa ciepła
% figure;
% h = heatmap(dBn_range, dAn_range, mse_matrix);
% h.Title = 'Błąd MSE w zależności od struktury dAn i dBn';
% h.XLabel = 'Opóźnienie wejścia (dBn)';
% h.YLabel = 'Opóźnienie sprzężenia (dAn)';
% h.Colormap = parula;
% 
% % Znalezienie minimum
% [minVal, idx] = min(mse_matrix(:));
% [row, col] = ind2sub(size(mse_matrix), idx);
% fprintf('\nNajlepsza struktura: dAn=%d, dBn=%d (MSE=%e)\n', ...
%     dAn_range(row), dBn_range(col), minVal);


%% Program: Przegląd zupełny dAn i dBn dla modelu NIELINIOWEGO (Zadanie 5)
clear all; close all; clc;

% --- Parametry modelu Wienera ---
sigma2 = 1;
a1 = -0.71; a2 = 0.36; b1 = 0.6; % Część liniowa
c = 1.0; d = 0.1;               % Nieliniowość statyczna: y = c*v + d*v^3
A = [1 a1 a2]; B = [0 b1];

% --- Konfiguracja Kwantyzatora (16-bit) ---
range = 10; % Zakres -5 do 5
levels = 2^16;
quantize = @(sig) round(sig * (levels/range)) * (range/levels);

% --- Parametry eksperymentu ---
L = 15;                % Zwiększona liczba neuronów dla nieliniowości
trainFcn = 'trainbr';  % Możesz zmienić na 'trainbr' dla lepszej gładkości
dAn_range = 1:5;
dBn_range = 1:5;
N_values = [1000, 10000];

all_results = cell(1, length(N_values));

for n_idx = 1:length(N_values)
    N = N_values(n_idx);
    fprintf('\n>>> Analiza NIELINIOWA (Wiener) dla N = %d <<<\n', N);
    
    % 1. Generowanie sygnału wejściowego
    us_raw = sqrt(sigma2) * randn(N, 1);
    
    % 2. Generowanie sygnału obiektu Wienera
    v = filter(B, A, us_raw);       % Element liniowy
    ys_raw = c*v + d*v.^3;          % Element nieliniowy
    ys_quantized = quantize(ys_raw); % Akwizycja danych (16-bit)
    
    % Konwersja na format komórkowy dla sieci
    us_cell = num2cell(us_raw');
    ys_cell = num2cell(ys_quantized');
    
    mse_matrix = zeros(length(dAn_range), length(dBn_range));
    
    for i = 1:length(dAn_range)
        for j = 1:length(dBn_range)
            curr_dAn = dAn_range(i);
            curr_dBn = dBn_range(j);
            
            % Definicja sieci NARX
            inputDelays = 0:curr_dBn;
            feedbackDelays = 1:curr_dAn;
            net = narxnet(inputDelays, feedbackDelays, L, 'open', trainFcn);
            
            % Konfiguracja uczenia
            net.trainParam.showWindow = false;
            net.divideParam.trainRatio = 70/100;
            net.divideParam.valRatio = 15/100;
            net.divideParam.testRatio = 15/100;
            
            % Przygotowanie i uczenie
            [x, xi, ai, t] = preparets(net, us_cell, {}, ys_cell);
            [net, ~] = train(net, x, t, xi, ai);
            
            % Obliczenie MSE
            y_pred = net(x, xi, ai);
            mse_matrix(i, j) = perform(net, t, y_pred);
            
            fprintf('  dAn=%d, dBn=%d | MSE: %e\n', curr_dAn, curr_dBn, mse_matrix(i,j));
        end
    end
    all_results{n_idx} = mse_matrix;
end

% --- GENEROWANIE TABEL I WYKRESÓW ---
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
    h.Title = ['Błąd MSE (Model Wienera) dla N = ' num2str(N)];
    h.XLabel = 'Opóźnienie wejścia (dBn)';
    h.YLabel = 'Opóźnienie sprzężenia (dAn)';
    h.Colormap = parula;
end