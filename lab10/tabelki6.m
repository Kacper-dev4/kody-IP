%% Program: Przegląd zupełny dAn i dBn dla ZADANIA 6 (Inwersja)
clear all; close all; clc;

% --- Parametry modelu Wienera ---
sigma2 = 1;
a1 = -0.71; a2 = 0.36; b1 = 0.6;
c = 1.0; d = 0.1;
A = [1 a1 a2]; B = [0 b1];

% --- Konfiguracja Kwantyzatora (16-bit) ---
range = 10; levels = 2^16;
quantize = @(sig) round(sig * (levels/range)) * (range/levels);

% --- Parametry eksperymentu ---
L_lag = 5;             % USTALONE opóźnienie rekonstrukcji u(t-L)
neurons = 15;          % Większa liczba neuronów dla trudnego zadania inwersji
trainFcn = 'trainbr'; 
dAn_range = 1:8;
dBn_range = 1:8;
N_values = [1000, 10000];

all_results = cell(1, length(N_values));

for n_idx = 1:length(N_values)
    N = N_values(n_idx);
    fprintf('\n>>> Analiza Inwersji dla N = %d (L_lag = %d) <<<\n', N, L_lag);
    
    % 1. Generowanie danych wejściowych (szum)
    u_raw = sqrt(sigma2) * randn(N, 1);
    
    % 2. Generowanie wyjścia obiektu Wienera + Kwantyzacja
    v = filter(B, A, u_raw);
    y_wiener = quantize(c*v + d*v.^3);
    
    % 3. Przygotowanie danych do Inwersji
    % Wejście sieci = Wyjście obiektu y
    % Wyjście sieci (cel) = Opóźnione wejście obiektu u
    us_inv_cell = num2cell(y_wiener');
    target_inv_cell = [num2cell(nan(1, L_lag)), num2cell(u_raw(1:end-L_lag)')];
    
    mse_matrix = zeros(length(dAn_range), length(dBn_range));
    
    for i = 1:length(dAn_range)
        for j = 1:length(dBn_range)
            curr_dAn = dAn_range(i);
            curr_dBn = dBn_range(j);
            
            % Definicja sieci NARX
            net = narxnet(0:curr_dBn, 1:curr_dAn, neurons, 'open', trainFcn);
            
            net.trainParam.showWindow = false;
            net.divideParam.trainRatio = 0.7;
            net.divideParam.valRatio = 0.15;
            net.divideParam.testRatio = 0.15;
            
            % Przygotowanie i uczenie
            [x, xi, ai, t] = preparets(net, us_inv_cell, {}, target_inv_cell);
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
    
    % Tworzenie tabeli zbiorczej
    Tabela = array2table(all_results{n_idx}, ...
        'VariableNames', cellstr("dBn_" + string(dBn_range)), ...
        'RowNames', cellstr("dAn_" + string(dAn_range)));
    
    fprintf('\n==================================================\n');
    fprintf('   WYNIKI MSE DLA N = %d\n', N);
    fprintf('==================================================\n');
    disp(Tabela);
    
    % Mapa ciepła
    figure;
    h = heatmap(dBn_range, dAn_range, all_results{n_idx});
    h.Title = ['Błąd MSE Inwersji (L=' num2str(L_lag) ') dla N = ' num2str(N)];
    h.XLabel = 'Opóźnienie sygnału y (dBn)';
    h.YLabel = 'Opóźnienie sprzężenia zwrotnego (dAn)';
    h.Colormap = hot;
end