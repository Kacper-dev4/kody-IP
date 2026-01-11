%% %%%%%%%%%%%% Zad4 %%%%%%%%%%%%%% 
clear all;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');

%% poszukiwanie losowe
N_samples = 1000; 
u = randn(N_samples, 1);
a_true = [0.6, -0.2]; b_true = [0.5, 0.3]; c_true = 0.8; d_true = 0.1;
p_true = [a_true, b_true, c_true, d_true]; 
u_step = ones(100, 1);
y_step_true = symuluj_model_wew4(p_true, u_step);
y = symuluj_model_wew4(p_true, u) + 0.01 * randn(N_samples, 1);
ileLokalnie = 100;
iteracje_test = [50, 200, 1000]; 
kolory = {'r--', 'g--', 'b--'};

% Przygotowanie tabeli wyników
wyniki_losowe = zeros(length(iteracje_test), 2); % [Best_MSE, Mean_MSE]

figure('Name', 'Zad4: Poszukiwanie Losowe'); 
plot(y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test)
    N_iter = iteracje_test(idx);
    mse_proby = zeros(10, 1);
    best_z_10_prob = inf;
    p_best_z_10_prob = zeros(1,7);
    
    for p = 1:10 
        [p_tmp, n_tmp] = puszukiwaniaLosowe4(u, y, 2, N_iter, 0.2, ileLokalnie);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_z_10_prob
            best_z_10_prob = n_tmp;
            p_best_z_10_prob = p_tmp;
        end
    end
    
    % Zapis do tabeli
    wyniki_losowe(idx, :) = [min(mse_proby), mean(mse_proby)];
    
    y_est = symuluj_model_wew4(p_best_z_10_prob, u_step);
    plot(y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (Best MSE: %.2e)', N_iter, min(mse_proby));
end
legend(legend_entries, 'Location', 'best');
xlabel('Próbka'); ylabel('y'); grid on; title('Zadanie 4: Poszukiwanie losowe');

% Wyświetlenie tabeli w konsoli
fprintf('\n--- TABELA WYNIKÓW: POSZUKIWANIE LOSOWE ---\n');
T1 = array2table(wyniki_losowe, 'RowNames', {'N_50', 'N_200', 'N_1000'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T1);

%% poszukiwanie losowe z lscurve
N_samples = 1000; 
u = randn(N_samples, 1);
y = symuluj_model_wew4(p_true, u) + 0.01 * randn(N_samples, 1);
y_step_true = symuluj_model_wew4(p_true, u_step);
iteracje_test_lsq = [20, 100, 300]; 

zakres = 2; mi = 0.1;
lb = [-2.9, -1.9, -10, -10, -10, -10 -2]; 
ub = [ 2.9,  1.9,  10  10,  10,  10 2];


% Przygotowanie tabeli wyników
wyniki_lsq = zeros(length(iteracje_test_lsq), 2);

figure('Name', 'Zad4: Lsqcurvefit'); 
plot(y_step_true, 'k', 'LineWidth', 2.5); hold on;
legend_entries = {'Obiekt rzeczywisty'};

for idx = 1:length(iteracje_test_lsq)
    N_iter = iteracje_test_lsq(idx);
    mse_proby = zeros(10, 1);
    best_z_10_prob = inf;
    
    for p = 1:10 
        [p_tmp, n_tmp] = poszukiwaniaLscurve4(u, y, 2, N_iter, lb, ub);
        current_mse = n_tmp / N_samples;
        mse_proby(p) = current_mse;
        
        if n_tmp < best_z_10_prob
            best_z_10_prob = n_tmp;
            p_best_z_10_prob = p_tmp;
        end
    end
    
    % Zapis do tabeli
    wyniki_lsq(idx, :) = [min(mse_proby), mean(mse_proby)];
    
    y_est = symuluj_model_wew4(p_best_z_10_prob, u_step);
    plot(y_est, kolory{idx}, 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('N=%d (Best MSE: %.2e)', N_iter, min(mse_proby));
end
legend(legend_entries, 'Location', 'best');
xlabel('Próbka'); ylabel('y'); grid on; title('Zadanie 4: Hybryda Lsqcurvefit');

% Wyświetlenie tabeli w konsoli
fprintf('\n--- TABELA WYNIKÓW: LSQCURVEFIT ---\n');
T2 = array2table(wyniki_lsq, 'RowNames', {'N_20', 'N_100', 'N_300'}, ...
    'VariableNames', {'Najlepszy_MSE', 'Sredni_MSE'});
disp(T2);



%%% funkcje 
function y_mod = symuluj_model(p, u)
    z = zeros(size(u));
    for k = 3:length(u)
        z(k) = p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2);
        if abs(z(k)) > 1e4 
            y_mod = ones(size(u)) * 1e6; return;
        end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end

function y_mod = symuluj_model_wew(p, u)
    z = zeros(size(u));
    for k = 3:length(u)
        z(k) = p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2);
        if abs(z(k)) > 1e4, y_mod = zeros(size(u))+1e6; return; end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end

function [best_p, best_n] = poszukiwaniaLscurve4(u, y, zakres, N, lb, ub)
    options = optimoptions('lsqcurvefit', 'Display', 'off', 'MaxIterations', 5); 
    best_n = inf;
    best_p = zeros(1,7);
    
    for k = 1:N
      
        p_start = zakres * (rand(1, 7) - 0.5);
        p_start(7) = 1 + 0.1*rand(); 
       
        try
            [p_opt, resnorm] = lsqcurvefit(@symuluj_model_wew4, p_start, u, y, lb, ub, options);
            if resnorm < best_n
                best_n = resnorm;
                best_p = p_opt;
            end
        catch
            continue; 
        end
    end
end



function err = obliczBladWienera4(p, u, y)
    z = zeros(size(u));
    a0 = p(7);
    for k = 3:length(u)
        z(k) = (p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2)) / a0;
        if abs(z(k)) > 1e4, err = 1e15; 
            return; 
        end 
    end
    y_mod = p(5)*z + p(6)*(z.^3);
    err = sum((y - y_mod).^2);
end

function y_mod = symuluj_model_wew4(p, u)
    z = zeros(size(u));
    if length(p) == 7
        a0 = p(7);
    else
        a0 = 1;
    end
    
    for k = 3:length(u)
        z(k) = (p(3)*u(k) + p(4)*u(k-1) - p(1)*z(k-1) - p(2)*z(k-2)) / a0;
        if abs(z(k)) > 1e4, y_mod = zeros(size(u))+1e6; 
            return;
        end
    end
    y_mod = p(5)*z + p(6)*(z.^3);
end


function [best_params, best_norm] = puszukiwaniaLosowe4(u, y, zakres, N, mi, ileLokalnie)
 
    bn = zakres * (rand(1, 7) - 0.5); 
    bn(7) = 1 + 0.2*rand();
    
    JMPLB = inf;
    B = bn;
    mi_lokalnie = mi / 10; 
    
    for k = 1:N
        bnn = B + mi * (rand(1, 7) - 0.5);
       
        if abs(bnn(7)) < 0.01, bnn(7) = 0.01; end
        
        norm_nowa = obliczBladWienera4(bnn, u, y);
        
        if norm_nowa < JMPLB
            temp_best_bn = bnn;
            temp_best_norm = norm_nowa;
            for j = 1:ileLokalnie
                b_lokalne = temp_best_bn + mi_lokalnie * (rand(1, 7) - 0.5);
                if abs(b_lokalne(7)) < 0.01, b_lokalne(7) = 0.01; end
                
                norm_lokalna = obliczBladWienera4(b_lokalne, u, y);
                if norm_lokalna < temp_best_norm
                    temp_best_norm = norm_lokalna;
                    temp_best_bn = b_lokalne;
                end
            end
            B = temp_best_bn;
            JMPLB = temp_best_norm;
        end
    end
    best_params = B;
    best_norm = JMPLB;
end

