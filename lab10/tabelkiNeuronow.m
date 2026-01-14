%% Program: Analiza wpływu liczby neuronów (Zadania 4, 5 i 6)
clear all; close all; clc;

% --- Ustawienia symulacji ---
neurons_vec = [5, 10, 20, 40, 50];
N_vec = [1000, 10000];
trainFcn = 'trainbr';
range = 10; levels = 2^16;
quantize = @(sig) round(sig * (levels/range)) * (range/levels);

% Parametry obiektów (identyczne jak wcześniej)
a1_lin = -1.2; a2_lin = 0.36; b1_lin = 0.6; % Zad 4
a1_w = -0.71; a2_w = 0.36; b1_w = 0.6; c_w = 1.0; d_w = 0.1; % Zad 5 i 6
L_lag = 5; % Dla zadania 6

% Prealokacja wyników
res4 = zeros(length(neurons_vec), length(N_vec));
res5 = zeros(length(neurons_vec), length(N_vec));
res6 = zeros(length(neurons_vec), length(N_vec));

for n_idx = 1:length(N_vec)
    N = N_vec(n_idx);
    fprintf('\nObliczenia dla N = %d...\n', N);
    
    % Generowanie sygnałów
    u = randn(N, 1);
    y4 = quantize(filter([0 b1_lin], [1 a1_lin a2_lin], u));
    v = filter([0 b1_w], [1 a1_w a2_w], u);
    y5 = quantize(c_w*v + d_w*v.^3);
    
    for h_idx = 1:length(neurons_vec)
        L = neurons_vec(h_idx);
        fprintf('  Testowanie L = %d neuronów\n', L);
        
        % --- ZADANIE 4 (Liniowy) ---
        net4 = narxnet(0:4, 1:4, L, 'open', trainFcn);
        net4.trainParam.showWindow = false;
        [x, xi, ai, t] = preparets(net4, num2cell(u'), {}, num2cell(y4'));
        [net4, ~] = train(net4, x, t, xi, ai);
        res4(h_idx, n_idx) = perform(net4, t, net4(x, xi, ai));
        
        % --- ZADANIE 5 (Wiener) ---
        net5 = narxnet(0:3, 1:5, L, 'open', trainFcn);
        net5.trainParam.showWindow = false;
        [x, xi, ai, t] = preparets(net5, num2cell(u'), {}, num2cell(y5'));
        [net5, ~] = train(net5, x, t, xi, ai);
        res5(h_idx, n_idx) = perform(net5, t, net5(x, xi, ai));
        
        % --- ZADANIE 6 (Inwersja) ---
        net6 = narxnet(0:7, 1:4, L, 'open', trainFcn); % dBn=4 dla lepszej inwersji
        net6.trainParam.showWindow = false;
        target6 = [num2cell(nan(1, L_lag)), num2cell(u(1:end-L_lag)')];
        [x, xi, ai, t] = preparets(net6, num2cell(y5'), {}, target6);
        [net6, ~] = train(net6, x, t, xi, ai);
        res6(h_idx, n_idx) = perform(net6, t, net6(x, xi, ai));
    end
end

% --- WYŚWIETLANIE TABEL ---
T4 = array2table(res4, 'RowNames', string(neurons_vec)+"_Neuronow", 'VariableNames', "N_"+string(N_vec));
T5 = array2table(res5, 'RowNames', string(neurons_vec)+"_Neuronow", 'VariableNames', "N_"+string(N_vec));
T6 = array2table(res6, 'RowNames', string(neurons_vec)+"_Neuronow", 'VariableNames', "N_"+string(N_vec));

fprintf('\n=== TABELA ZADANIE 4 (Liniowy ARX) ===\n'); disp(T4);
fprintf('\n=== TABELA ZADANIE 5 (Obiekt Wienera) ===\n'); disp(T5);
fprintf('\n=== TABELA ZADANIE 6 (Inwersja Wienera) ===\n'); disp(T6);